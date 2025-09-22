import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'package:wavex/core/helper/cache_helper/cache_helper.dart';
import 'package:wavex/core/theme/colors.dart';
import 'package:wavex/main.dart';

import '../../../../core/app_localization.dart';
import '../../../../core/components/bottom_navigation_bar.dart';
import '../../../../core/components/bottom_wave_painter.dart';
import '../../../../core/route/route_strings/route_strings.dart';
import '../../../shop_cart_screen/data/models/get_cart_response.dart';
import '../../../shop_cart_screen/logic/shop_cart_cubit.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List<OrderItems> _cartItems = [];

  double get totalPrice {
    return _cartItems.fold(0, (sum, item) {
      final price = double.tryParse(item.price ?? "0") ?? 0;
      final quantity = item.quantity ?? 1;
      return sum + (price * quantity);
    });
  }

  OrderData data = OrderData();

  @override
  void initState() {
    super.initState();
    ShopCartCubit.get(context).getCart(orderId: CacheHelper.getdata(key: "orderId"));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              HeaderWidget(isWithBack: true),
              BlocListener<ShopCartCubit, ShopCartState>(
                listener: (context, state) {
                  if (state is GetCartSuccessState) {
                    setState(() {
                      _cartItems = state.cartResponse.data?.orderItems ?? [];
                      data = state.cartResponse.data??OrderData();
                    });
                  }
                },
                child: const SizedBox.shrink(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Checkout Now Title
                      Row(
                        children: [
                          Image.asset("assets/images/water_drop_icon.png"),
                          const SizedBox(width: 12),
                          Text(
                            localizations.translate("checkout_now"),
                            style: GoogleFonts.inter().copyWith(
                              color: const Color(0xFF2E535F),
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Total Price Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4F8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              localizations.translate("total_price"),
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${totalPrice.toStringAsFixed(2)} GBP',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Cart Items from API
                      ..._cartItems.map((item) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E5266),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4DD0E1),
                                  borderRadius: BorderRadius.circular(8),
                                  image: item.product?.image != null
                                      ? DecorationImage(
                                    image: NetworkImage(item.product!.image!),
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                ),
                                child: item.product?.image == null
                                    ? const Center(
                                  child: Text(
                                    'WAVEX',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item.product?.name ?? "Product"} (x${item.quantity ?? 1})',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${item.price} GBP',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 20),

                      // Security Information
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD5E4E6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.lock,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              localizations.translate("payment_security_text"),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.primaryColor,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Continue Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            navigatorKey.currentState!.pushNamed(
                              RouteStrings.paymentOptionsScreen,
                              arguments: {
                                "orderId" : data.id??""
                              }
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            localizations.translate("continue_btn"),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 0),
                painter: BottomWavePainter(),
              ),
              const BottomNavigation(currentIndex: 2),
            ],
          ),
        ],
      ),
    );
  }
}
