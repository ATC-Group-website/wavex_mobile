import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'dart:math' as math;

import '../../../../../core/app_localization.dart';
import '../../../../../core/components/bottom_wave_painter.dart';
import '../../../../../core/components/gradient_button.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/route/route_strings/route_strings.dart';
import '../../../../../main.dart';
import '../../../../../core/theme/colors.dart';

/// يسمح بكتابة + مرة واحدة فقط وفي أول النص
class _SinglePlusFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // لو المستخدم كتب + في النص بعد أول خانة → نشيله
    if (text.contains('+') && !text.startsWith('+')) {
      final fixed = text.replaceAll('+', '');
      return newValue.copyWith(
        text: fixed,
        selection: TextSelection.collapsed(offset: fixed.length),
      );
    }

    // لو كتب + أكتر من مرة → نخلي أول واحدة بس
    if (text.indexOf('+') != text.lastIndexOf('+')) {
      final firstPlus = text.indexOf('+');
      final fixed = text.replaceRange(firstPlus + 1, null,
          text.substring(firstPlus + 1).replaceAll('+', ''));
      return newValue.copyWith(
        text: fixed,
        selection: TextSelection.collapsed(offset: fixed.length),
      );
    }

    return newValue;
  }
}

class RegisterStepOneScreen extends StatefulWidget {
  const RegisterStepOneScreen({super.key});

  @override
  State<RegisterStepOneScreen> createState() => _RegisterStepOneScreenState();
}

class _RegisterStepOneScreenState extends State<RegisterStepOneScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String _selectedGender = 'female';
  bool _agreeToTerms = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _launchUrl({
    required String printUrl,
  }) async {
    Uri url = Uri.parse(
      printUrl,
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header with gradient and status bar
          HeaderWidget(
            isWithBack: true,
          ),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Full Name field
                    _buildFieldLabel(
                      AppLocalizations.of(context).translate("first_name"),
                      isRequired: true,
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _firstNameController,
                      hintText: AppLocalizations.of(context)
                          .translate("enter_first_name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)
                              .translate("first_name_required");
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Full Name field
                    _buildFieldLabel(
                      AppLocalizations.of(context).translate("last_name"),
                      isRequired: true,
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _lastNameController,
                      hintText: AppLocalizations.of(context)
                          .translate("enter_last_name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)
                              .translate("last_name_required");
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Email field
                    _buildFieldLabel(
                        AppLocalizations.of(context).translate("email"),
                        isRequired: true),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _emailController,
                      hintText:
                          AppLocalizations.of(context).translate("enter_email"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)
                              .translate("email_required");
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return AppLocalizations.of(context)
                              .translate("email_invalid");
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Mobile Number field
                    _buildFieldLabel(
                        AppLocalizations.of(context).translate("mobile_number"),
                        isRequired: true),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _mobileController,
                      hintText: AppLocalizations.of(context)
                          .translate("enter_mobile"),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLocalizations.of(context)
                              .translate("mobile_required");
                        }

                        // نشيل المسافات الأول
                        final cleaned = value.replaceAll(' ', '');

                        // regex: يبدأ بـ +44 ويليه 10 أرقام أو يبدأ بـ 0 ويليه 10 أرقام
                        final pattern = RegExp(r'^(?:\+44\d{10}|0\d{10})$');

                        if (!pattern.hasMatch(cleaned)) {
                          return "Enter a valid UK number(e.g. 07123456789 or +447123456789)";
                        }

                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
                        _SinglePlusFormatter(),
                        // ✅ custom formatter علشان نمنع أكتر من +
                      ],
                    ),

                    // _buildTextField(
                    //   controller: _mobileController,
                    //   hintText: AppLocalizations.of(context)
                    //       .translate("enter_mobile"),
                    //   keyboardType: TextInputType.phone,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return AppLocalizations.of(context)
                    //           .translate("mobile_required");
                    //     }
                    //     return null;
                    //   },
                    // ),

                    const SizedBox(height: 20),

                    // Date of Birth field
                    _buildFieldLabel(
                        AppLocalizations.of(context).translate("dob"),
                        isRequired: true),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _selectDate,
                      child: AbsorbPointer(
                        child: _buildTextField(
                          controller: _dobController,
                          hintText: AppLocalizations.of(context)
                              .translate("dob_hint"),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value == 'YYY-MM-DD') {
                              return AppLocalizations.of(context)
                                  .translate("dob_required");
                            }
                            return null;
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Gender field
                    _buildFieldLabel(
                        AppLocalizations.of(context).translate("gender"),
                        isRequired: true),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGenderButton("male"),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildGenderButton(
                            "female",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildGenderButton(
                            "other",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Terms and conditions checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreeToTerms = value ?? false;
                            });
                          },
                          activeColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: AppLocalizations.of(context)
                                        .translate("terms_agree"),
                                    style: GoogleFonts.leagueSpartan().copyWith(
                                      color: const Color(0xFF252525),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  TextSpan(
                                    text: AppLocalizations.of(context)
                                        .translate("terms_of_use"),
                                    style: GoogleFonts.leagueSpartan().copyWith(
                                      color: AppColors.primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _launchUrl(
                                            printUrl:
                                                "https://wavexsports.com/terms-and-conditions");
                                      },
                                  ),
                                  TextSpan(
                                    text:
                                        " ${AppLocalizations.of(context).translate("and")} ",
                                    style: GoogleFonts.leagueSpartan().copyWith(
                                      color: const Color(0xFF252525),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  TextSpan(
                                    text: AppLocalizations.of(context)
                                        .translate("privacy_policy"),
                                    style: GoogleFonts.leagueSpartan().copyWith(
                                      color: AppColors.primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _launchUrl(
                                            printUrl:
                                                "https://wavexsports.com/privacy-policy");
                                      },
                                  ),
                                  const TextSpan(text: '.'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Next Button
                    // Center(
                    //   child: ElevatedButton(
                    //     onPressed: _isLoading ? null : _handleRegistration,
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: const Color(0xFF4A9FB0),
                    //       padding: const EdgeInsets.symmetric(
                    //           horizontal: 60, vertical: 5),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(28),
                    //       ),
                    //       elevation: 0,
                    //     ),
                    //     child: _isLoading
                    //         ? const CircularProgressIndicator(
                    //             valueColor:
                    //                 AlwaysStoppedAnimation<Color>(Colors.white),
                    //           )
                    //         : Text(
                    //             'Next',
                    //             style: GoogleFonts.leagueSpartan().copyWith(
                    //               color: Colors.white,
                    //               fontSize: 24,
                    //               fontWeight: FontWeight.w600,
                    //             ),
                    //           ),
                    //   ),
                    // ),
                    GradientButton(
                      text: AppLocalizations.of(context).translate("next"),
                      loading: _isLoading,
                      onPressed: _handleRegistration,
                    ),

                    // const SizedBox(height: 20),
                    //
                    // // Or sign up with
                    // Center(
                    //   child: Text(
                    //     AppLocalizations.of(context)
                    //         .translate("or_sign_up_with"),
                    //     style: GoogleFonts.leagueSpartan().copyWith(
                    //       color: const Color(0xFF252525),
                    //       fontSize: 12,
                    //       fontWeight: FontWeight.w300,
                    //     ),
                    //   ),
                    // ),
                    //
                    // const SizedBox(height: 24),
                    //
                    // // Social login buttons
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     _buildSocialButton(
                    //       icon: Icons.g_mobiledata,
                    //       onPressed: () => _handleSocialLogin('Google'),
                    //     ),
                    //     const SizedBox(width: 16),
                    //     _buildSocialButton(
                    //       icon: Icons.facebook,
                    //       onPressed: () => _handleSocialLogin('Facebook'),
                    //     ),
                    //     const SizedBox(width: 16),
                    //     _buildSocialButton(
                    //       icon: Icons.fingerprint,
                    //       onPressed: () => _handleSocialLogin('Biometric'),
                    //     ),
                    //   ],
                    // ),

                    const SizedBox(height: 20),

                    // Login link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                .translate("already_have_account"),
                            style: GoogleFonts.leagueSpartan().copyWith(
                              color: const Color(0xFF252525),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to login
                              navigatorKey.currentState!
                                  .pushNamed(RouteStrings.loginScreen);
                            },
                            child: Text(
                              AppLocalizations.of(context).translate("login"),
                              style: GoogleFonts.leagueSpartan().copyWith(
                                color: AppColors.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 0),
            painter: BottomWavePainter(),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.leagueSpartan().copyWith(
            color: const Color(0xFF252525),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          // style: const TextStyle(
          //   fontSize: 16,
          //   fontWeight: FontWeight.w500,
          //   color: Color(0xFF333333),
          // ),
        ),
        if (isRequired)
          const Text(
            ' *',
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters, // ✅ new param
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE2F2F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        inputFormatters: inputFormatters,
        // ✅ applied here
        style: GoogleFonts.leagueSpartan().copyWith(
          color: AppColors.primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          hintText: hintText,
          hintStyle: GoogleFonts.leagueSpartan().copyWith(
            color: AppColors.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  // Widget _buildTextField({
  //   required TextEditingController controller,
  //   required String hintText,
  //   TextInputType? keyboardType,
  //   String? Function(String?)? validator,
  // }) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFE2F2F5),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: TextFormField(
  //       controller: controller,
  //       keyboardType: keyboardType,
  //       validator: validator,
  //       style: GoogleFonts.leagueSpartan().copyWith(
  //         color: AppColors.primaryColor,
  //         fontSize: 20,
  //         fontWeight: FontWeight.w400,
  //       ),
  //       // style: const TextStyle(
  //       //   fontSize: 16,
  //       //   color: Color(0xFF666666),
  //       // ),
  //       decoration: InputDecoration(
  //         border: InputBorder.none,
  //         contentPadding: const EdgeInsets.all(16),
  //         hintText: hintText,
  //         hintStyle: GoogleFonts.leagueSpartan().copyWith(
  //           color: AppColors.primaryColor,
  //           fontSize: 18,
  //           fontWeight: FontWeight.w400,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildGenderButton(String gender) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFF668E95) : const Color(0xFFE2F2F5),
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: Color(0xff48A5B9), width: 5)
                : null),
        child: Center(
          child: Text(
            gender,
            style: GoogleFonts.leagueSpartan().copyWith(
              color: isSelected ? Colors.white : const Color(0xFF666666),
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            // style: TextStyle(
            //   fontSize: 16,
            //   fontWeight: FontWeight.w500,
            //   color: isSelected ? Colors.white : const Color(0xFF666666),
            // ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xFF4E9BAA),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime initialDate;

    if (_dobController.text.isNotEmpty) {
      initialDate = DateTime.parse(_dobController.text);
    } else {
      initialDate = DateTime(
        DateTime.now().year - 16,
        DateTime.now().month,
        DateTime.now().day,
      );
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      // 16 years ago

      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF26C6DA),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _handleRegistration() async {
    // if (!_formKey.currentState!.validate()) {
    //   return;
    // }

    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context).translate("agree_terms_error"),
              ),
              backgroundColor: Colors.red,
            ),
          );
        return;
      } else {
        navigatorKey.currentState!
            .pushNamed(RouteStrings.registerStepTwoScreen, arguments: {
          "email": _emailController.text.trim(),
          "firstName": _firstNameController.text.trim(),
          "lastName": _lastNameController.text.trim(),
          "gender": _selectedGender,
          "phone": _mobileController.text.trim(),
          "dop": _dobController.text
        });
      }
    }

    // setState(() {
    //   _isLoading = true;
    // });

    // // Simulate registration process
    // await Future.delayed(const Duration(seconds: 2));
    //
    // setState(() {
    //   _isLoading = false;
    // });

    // // Show success message
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('Registration successful!'),
    //     backgroundColor: Color(0xFF26C6DA),
    //   ),
    // );
  }

  void _handleSocialLogin(String provider) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$provider registration pressed'),
          backgroundColor: const Color(0xFF26C6DA),
        ),
      );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    super.dispose();
  }
}
