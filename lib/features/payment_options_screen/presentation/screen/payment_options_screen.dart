import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'package:wavex/core/constants/constants.dart';
import 'package:wavex/core/theme/colors.dart';

import '../../../../core/app_localization.dart';
import '../../../../core/components/bottom_navigation_bar.dart';
import '../../../../core/components/bottom_wave_painter.dart';
import '../../../../core/helper/cache_helper/cache_helper.dart';
import '../../../../core/route/route_strings/route_strings.dart';
import '../../../../main.dart';
import '../../../my_addresses_screen/data/models/get_my_addresses.dart';
import '../../../my_addresses_screen/logic/my_address_cubit.dart';
import '../../logic/payment_options_cubit.dart';

class PaymentOptionsScreen extends StatefulWidget {
  const PaymentOptionsScreen({Key? key, required this.orderId})
      : super(key: key);

  final String orderId;

  @override
  State<PaymentOptionsScreen> createState() => _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends State<PaymentOptionsScreen> {
  String? selectedPaymentMethod;
  AddressData? selectedAddress;
  List<AddressData> addresses = [];

  void _addNewAddress() {
    navigatorKey.currentState!.pushNamed(RouteStrings.addManualAddressScreen,
        arguments: {"addressId": null});
  }

  void _showAddressBottomSheet() async {
    final localizations = AppLocalizations.of(context)!;

    final result = await showModalBottomSheet<AddressData>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // My Addresses Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/images/water_drop_icon.png"),
                        const SizedBox(width: 12),
                        Text(
                          localizations.translate("my_addresses"),
                          style: GoogleFonts.inter().copyWith(
                            color: AppColors.primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: _addNewAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        localizations.translate("add_new"),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context, address);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDF7F9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.teal,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(address.name ?? "",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87)),
                              const SizedBox(height: 8),
                              Text(address.phone ?? "",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xCC23707C),
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(height: 8),
                              Text(address.address ?? "",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xCC23707C),
                                      height: 1.4)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedAddress = result;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    MyAddressCubit.get(context).getMyAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              HeaderWidget(isWithBack: true),
              BlocListener<MyAddressCubit, MyAddressState>(
                listener: (context, state) {
                  if (state is GetMyAddressesSuccessState) {
                    setState(() {
                      addresses = state.myAddressesResponse.data ?? [];
                      selectedAddress = addresses.firstWhere(
                        (element) => element.isDefault == 1,
                        orElse: () =>
                            addresses.first, // عشان لو مفيش ولا واحد default
                      );
                    });
                  }
                },
                child: SizedBox.shrink(),
              ),
              BlocListener<PaymentOptionsCubit, PaymentOptionsState>(
                listener: (context, state) async {
                  if (state is PurchaseSuccessState) {
                    await makePayment(
                      state.purchaseResponse.data?.clientSecret ?? "",
                      state.orderId,
                    );
                  }
                },
                child: SizedBox.shrink(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset("assets/images/water_drop_icon.png"),
                          const SizedBox(width: 12),
                          Text(localizations.translate("checkout_now"),
                              style: GoogleFonts.inter().copyWith(
                                  color: const Color(0xFF2E535F),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Container(
                      //   width: double.infinity,
                      //   padding: const EdgeInsets.symmetric(
                      //       vertical: 12, horizontal: 16),
                      //   decoration: BoxDecoration(
                      //       color: const Color(0xFF37474F),
                      //       borderRadius: BorderRadius.circular(8)),
                      //   child: Text(
                      //     localizations.translate("choose_payment_option"),
                      //     style: const TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.w500),
                      //   ),
                      // ),
                      // const SizedBox(height: 16),
                      //
                      // // Apple Pay
                      // _buildPaymentOption(
                      //   'apple_pay',
                      //   _paymentCardWidget(localizations.translate("apple_pay"),
                      //       Icons.apple, Colors.black, 'apple_pay'),
                      // ),
                      // const SizedBox(height: 12),
                      //
                      // // Google Pay
                      // _buildPaymentOption(
                      //   'google_pay',
                      //   _paymentCardWidget(
                      //       localizations.translate("google_pay"),
                      //       null,
                      //       Colors.white,
                      //       'google_pay'),
                      // ),
                      // const SizedBox(height: 12),
                      //
                      // // Pay by Card
                      // _buildPaymentOption(
                      //   'card',
                      //   _paymentCardWidget(
                      //       localizations.translate("pay_by_card"),
                      //       null,
                      //       Colors.white,
                      //       'card',
                      //       isCard: true,
                      //       description:
                      //           localizations.translate("card_payment_desc")),
                      // ),
                      // const SizedBox(height: 12),
                      //
                      // // Internet banking
                      // _buildPaymentOption(
                      //   'banking',
                      //   _paymentCardWidget(
                      //       localizations.translate("pay_via_banking"),
                      //       Icons.account_balance,
                      //       Colors.black,
                      //       'banking',
                      //       description: localizations
                      //           .translate("banking_payment_desc")),
                      // ),
                      // const SizedBox(height: 24),

                      // Address section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: const Color(0xFFB3D5DB),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.translate("address"),
                              style: GoogleFonts.inter().copyWith(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(selectedAddress?.name ?? "",
                                style: GoogleFonts.leagueSpartan().copyWith(
                                    color: const Color(0xFF44858F),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400)),
                            Text(selectedAddress?.address ?? "",
                                style: GoogleFonts.leagueSpartan().copyWith(
                                    color: const Color(0xFF44858F),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400)),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: _showAddressBottomSheet,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                ),
                                child: Text(
                                    localizations.translate("change_address"),
                                    style: GoogleFonts.inter().copyWith(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Checkout button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          // onPressed: selectedPaymentMethod != null
                          //     ? () async => await makePayment()
                          //     : null,
                          onPressed: selectedAddress != null
                              ? () async {
                                  /// make purchase
                                  PaymentOptionsCubit.get(context).purchase(
                                    orderId: widget.orderId,
                                    addressId: selectedAddress!.id,
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                          ),
                          child: Text(
                              localizations.translate("checkout_now_btn"),
                              style: GoogleFonts.inter().copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 0),
                  painter: BottomWavePainter()),
              const BottomNavigation(currentIndex: 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _paymentCardWidget(
      String title, IconData? icon, Color iconColor, String value,
      {bool isCard = false, String? description}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCard ? const Color(0xFFF1F8E9) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: selectedPaymentMethod == value
                ? AppColors.primaryColor
                : Colors.grey.shade300,
            width: selectedPaymentMethod == value ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: iconColor, borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: Colors.white, size: 24),
                )
              else if (!isCard)
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(title[0],
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                ),
              const SizedBox(width: 16),
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500)),
              const Spacer(),
              if (isCard)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: const Color(0xFF1565C0),
                          borderRadius: BorderRadius.circular(4)),
                      child: const Text('VISA',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                      child: const Center(
                          child: Text('M',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold))),
                    ),
                  ],
                ),
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: 8),
            Text(description,
                style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String value, Widget child) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = value;
        });
      },
      child: child,
    );
  }

  // Future<void> makePayment(
  //     String? paymentIntentClientSecret, int sessionId) async {
  //   try {
  //     if (paymentIntentClientSecret == null) return;
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: paymentIntentClientSecret,
  //         merchantDisplayName: CacheHelper.getdata(key: "userName") ?? "Guest",
  //       ),
  //     );
  //     await _processPayment(context, sessionId);
  //   } catch (_) {}
  // }
  Future<void> makePayment(
      String? paymentIntentClientSecret, orderId) async {
    try {
      if (paymentIntentClientSecret == null) return;
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: CacheHelper.getdata(key: "userName") ?? "Guest",
        ),
      );
      await _processPayment(context, orderId);
    } catch (_) {}
  }

  Future<void> _processPayment(BuildContext context, String orderId) async {
    try {
      await Stripe.instance.presentPaymentSheet();

      // ✅ Success → go to success screen
      navigatorKey.currentState!
          .pushNamed(RouteStrings.transactionSuccessScreen);
    } on StripeException catch (e) {
      // ✅ StripeException has error.message
      final errorMessage =
          e.error.localizedMessage ?? e.error.message ?? "Payment canceled";

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );

      // ✅ Failed → go to failed screen (once only)
      navigatorKey.currentState!.pushNamed(
        RouteStrings.payOrderTransactionFailedScreen,
        arguments: {"addressId": selectedAddress!.id, "orderId": orderId},
      );
    } catch (e) {
      // ✅ fallback for unexpected errors
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(e.toString())),
        );

      // ✅ Failed → go to failed screen (once only)
      navigatorKey.currentState!.pushNamed(
        RouteStrings.payOrderTransactionFailedScreen,
        arguments: {"addressId": selectedAddress!.id, "orderId": orderId},
      );
    }
  }

// Future<void> _processPayment(BuildContext context, String orderId) async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet();
  //
  //     navigatorKey.currentState!
  //         .pushNamed(RouteStrings.transactionSuccessScreen);
  //   } on StripeException catch (e) {
  //     // ✅ StripeException has error.message
  //     final errorMessage =
  //         e.error.localizedMessage ?? e.error.message ?? "Payment canceled";
  //
  //     if (errorMessage.contains("canceled")) {
  //       navigatorKey.currentState!.pushNamed(
  //         RouteStrings.payOrderTransactionFailedScreen,
  //         arguments: {"addressId": selectedAddress!.id, "orderId": orderId},
  //       );
  //     } else {
  //       navigatorKey.currentState!.pushNamed(
  //         RouteStrings.payOrderTransactionFailedScreen,
  //         arguments: {"addressId": selectedAddress!.id, "orderId": orderId},
  //       );
  //     }
  //
  //     ScaffoldMessenger.of(context)
  //       ..hideCurrentSnackBar()
  //       ..showSnackBar(
  //         SnackBar(
  //           content: Text(e.error.message ?? ""), // <-- show Stripe error
  //         ),
  //       );
  //
  //     navigatorKey.currentState!.pushNamed(
  //       RouteStrings.payOrderTransactionFailedScreen,
  //       arguments: {"addressId": selectedAddress!.id, "orderId": orderId},
  //     );
  //   } catch (e) {
  //     // ✅ fallback for unexpected errors
  //     ScaffoldMessenger.of(context)
  //       ..hideCurrentSnackBar()
  //       ..showSnackBar(
  //         SnackBar(
  //           content: Text(
  //             e.toString(), // <-- show raw error (can replace with nicer handling)
  //           ),
  //         ),
  //       );
  //
  //     navigatorKey.currentState!.pushNamed(
  //       RouteStrings.payOrderTransactionFailedScreen,
  //       arguments: {"addressId": selectedAddress!.id, "orderId": orderId},
  //     );
  //   }
  // }
}
