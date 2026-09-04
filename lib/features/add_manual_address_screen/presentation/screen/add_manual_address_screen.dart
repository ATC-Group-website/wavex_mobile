import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';
import 'package:wavex/features/add_manual_address_screen/data/models/address_request_body.dart';
import 'package:wavex/features/add_manual_address_screen/logic/address_cubit.dart';
import 'package:wavex/main.dart';

import '../../../../core/components/bottom_navigation_bar.dart';
import '../../../../core/components/bottom_wave_painter.dart';
import '../../../../core/components/header_widget.dart';
import '../../../../core/theme/colors.dart';
import '../../data/models/get_address_byId_response.dart';

class AddManualAddressScreen extends StatefulWidget {
  const AddManualAddressScreen({Key? key, this.addressId}) : super(key: key);

  final int? addressId;

  @override
  State<AddManualAddressScreen> createState() => _AddManualAddressScreenState();
}

class _AddManualAddressScreenState extends State<AddManualAddressScreen> {
  TextEditingController _addressLabelController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  // TextEditingController _districtController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  bool _isDefaultAddress = false;

  void _saveAddress() {
    if (_addressLabelController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Please enter an address name')),
        );
      return;
    }
    if (widget.addressId != null) {
      AddressCubit.get(context).updateAddress(
        addressId: widget.addressId!,
        address: AddressRequestBody(
          name: _addressLabelController.text.trim(),
          address: _addressController.text.trim(),
          postalCode: _postalCodeController.text.trim(),
          // district: _districtController.text.trim(),
          notes: _notesController.text.trim(),
          email: _emailController.text.trim(),
          isDefault: _isDefaultAddress,
          phone: _phoneController.text.trim(),
        ),
      );
    } else {
      AddressCubit.get(context).addAddress(
        address: AddressRequestBody(
          name: _addressLabelController.text.trim(),
          address: _addressController.text.trim(),
          postalCode: _postalCodeController.text.trim(),
          // district: _districtController.text.trim(),
          notes: _notesController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          isDefault: _isDefaultAddress,
        ),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE2F2F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.leagueSpartan().copyWith(
            color: const Color(0xFF45818B),
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.addressId != null) {
      AddressCubit.get(context).getAddressById(addressId: widget.addressId!);
    }
    super.initState();
  }

  AddressData userAddress = AddressData();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressCubit, AddressState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        // TODO: implement listener
        if (state is GetAddressByIdSuccessState) {
          userAddress = state.addressByIdResponse.data ?? AddressData();
          print(userAddress.isDefault);
          _addressLabelController.text = userAddress.name ?? "";
          _emailController.text = userAddress.email ?? "";
          _phoneController.text = userAddress.phone ?? "";
          _postalCodeController.text = userAddress.postalCode.toString() ?? "";
          _addressController.text = userAddress.address ?? "";
          _isDefaultAddress = userAddress.isDefault == 0 ? false : true;
          // _notesController.text = userAddress.address??"";
        }
        if (state is AddAddressSuccessState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.addressResponse.message ?? "",
                ),
                backgroundColor: Colors.green,
              ),
            );
          navigatorKey.currentState!.pop();

          // navigatorKey.currentState!.pushNamed(
          //   RouteStrings.myAddressesScreen,
          //   // (route) => false,
          // );
        }
        if (state is UpdateAddressSuccessState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.addressResponse.message ?? "",
                ),
                backgroundColor: Colors.green,
              ),
            );
          navigatorKey.currentState!.pop();

          // navigatorKey.currentState!.pushReplacementNamed(
          //   RouteStrings.myAddressesScreen,
          // );
        }
        if (state is AddAddressErrorState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.error ?? "",
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state is UpdateAddressErrorState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.error ?? "",
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  // Header
                  HeaderWidget(
                    isWithBack: true,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Add New Address title
                          Row(
                            children: [
                              Image.asset("assets/images/water_drop_icon.png"),
                              const SizedBox(width: 12),
                              Text(
                                widget.addressId != null
                                    ? 'Update Address'
                                    : 'Add New Address',
                                style: GoogleFonts.inter().copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          // Address Label
                          Text(
                            'Name',
                            style: GoogleFonts.leagueSpartan().copyWith(
                              color: const Color(0xFF45818B),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: _addressLabelController,
                            hintText: 'add your address name',
                          ),
                          const SizedBox(height: 24),

                          // Region
                          Text(
                            'Email',
                            style: GoogleFonts.leagueSpartan().copyWith(
                              color: const Color(0xFF45818B),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: _emailController,
                            hintText: 'add your email',
                          ),
                          // const SizedBox(height: 24),
                          //
                          // // District
                          // Text(
                          //   'District',
                          //   style: GoogleFonts.leagueSpartan().copyWith(
                          //     color: const Color(0xFF45818B),
                          //     fontSize: 20,
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // ),
                          // const SizedBox(height: 12),
                          // _buildTextField(
                          //   controller: _districtController,
                          //   hintText: 'add your district',
                          // ),
                          const SizedBox(height: 24),
                          // District
                          Text(
                            'Phone',
                            style: GoogleFonts.leagueSpartan().copyWith(
                              color: const Color(0xFF45818B),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            hintText: 'add your phone',
                          ),
                          const SizedBox(height: 24),

                          // Postal Code
                          Text(
                            'Postal Code',
                            style: GoogleFonts.leagueSpartan().copyWith(
                              color: const Color(0xFF45818B),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: _postalCodeController,
                            // keyboardType: TextInputType.number,
                            hintText: '•••••',
                          ),
                          const SizedBox(height: 24),

                          // Address
                          Text(
                            'Address',
                            style: GoogleFonts.leagueSpartan().copyWith(
                              color: const Color(0xFF45818B),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: _addressController,
                            hintText: 'add your detailed address',
                          ),
                          const SizedBox(height: 24),

                          // Notes
                          Text(
                            'Notes',
                            style: GoogleFonts.leagueSpartan().copyWith(
                              color: const Color(0xFF45818B),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            controller: _notesController,
                            hintText: 'add your notes',
                          ),
                          const SizedBox(height: 20),
                          // Set as default checkbox
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Checkbox(
                                value: _isDefaultAddress,
                                onChanged: (value) {
                                  setState(() {
                                    _isDefaultAddress = value ?? false;
                                  });
                                },
                                activeColor: AppColors.primaryColor,
                              ),
                              Text('Set as default address',
                                  style: GoogleFonts.leagueSpartan().copyWith(
                                    color: const Color(0xFF44858F),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w300,
                                  )),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _saveAddress,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 10),
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shadowColor: Colors.black26,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: Text(
                                'Save',
                                style: GoogleFonts.inter().copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, 0),
                    painter: BottomWavePainter(),
                  ),
                  const BottomNavigation(
                    currentIndex: 2,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _addressLabelController.dispose();
    _emailController.dispose();
    // _districtController.dispose();
    _postalCodeController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
