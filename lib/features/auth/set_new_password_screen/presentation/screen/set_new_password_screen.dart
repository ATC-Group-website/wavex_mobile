import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'package:wavex/features/auth/password_reset_screen/logic/reset_password_cubit.dart';

import '../../../../../core/app_localization.dart';
import '../../../../../core/components/bottom_wave_painter.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../main.dart';
import '../../../../../core/theme/colors.dart';

class SetNewPasswordScreen extends StatefulWidget {
  final String email;

  const SetNewPasswordScreen({
    Key? key,
    this.email = "Demo@gmail.com",
  }) : super(key: key);

  @override
  _SetNewPasswordScreenState createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Password validation states
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasSpecialChar = false;
  bool _passwordsMatch = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _validatePassword(String password) {
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      _passwordsMatch = password.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          password == _confirmPasswordController.text;
    });
  }

  void _validateConfirmPassword(String confirmPassword) {
    setState(() {
      _passwordsMatch = confirmPassword.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          confirmPassword == _passwordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Color(0xFF2C5F5F)),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      // ),
      body: Column(
        children: [
          // Header with gradient
          HeaderWidget(
            isWithBack: true,
          ),

          BlocListener<ResetPasswordCubit, ResetPasswordState>(
            listener: (context, state) {
              if (state is ChangePasswordSuccessState) {
                // Simulate API call
                setState(() {
                  _isLoading = false;
                });

                // Show success message
                ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context).translate("password_success"),
                    ),
                    backgroundColor: const Color(0xFF4CAF50),
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                // Navigate to login screen or main app
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            child: SizedBox.shrink(),
          ),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),

                      // Title and Description
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // 'Enter New Password',
                              AppLocalizations.of(context)
                                  .translate("enter_new_password"),
                              style: GoogleFonts.poppins().copyWith(
                                color: AppColors.primaryColor,
                                fontSize: 27,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              // 'Set Complex passwords to protect that contain a capital letter and special character',
                              AppLocalizations.of(context)
                                  .translate("password_description"),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins().copyWith(
                                color: const Color(0xFF7F909F),
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // // Password Requirements
                      // SlideTransition(
                      //   position: _slideAnimation,
                      //   child: FadeTransition(
                      //     opacity: _fadeAnimation,
                      //     child: _buildPasswordRequirements(),
                      //   ),
                      // ),
                      //
                      // SizedBox(height: 30),

                      // Form Fields
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Password Field
                              Text(
                                // 'Password',
                                AppLocalizations.of(context)
                                    .translate("password"),
                                style: GoogleFonts.poppins().copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildPasswordField(
                                controller: _passwordController,
                                isVisible: _isPasswordVisible,
                                onVisibilityToggle: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                onChanged: _validatePassword,
                              ),

                              const SizedBox(height: 24),

                              // Confirm Password Field
                              Text(
                                // 'Confirm Password',

                                AppLocalizations.of(context)
                                    .translate("confirm_password"),
                                style: GoogleFonts.poppins().copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildPasswordField(
                                controller: _confirmPasswordController,
                                isVisible: _isConfirmPasswordVisible,
                                onVisibilityToggle: () {
                                  setState(() {
                                    _isConfirmPasswordVisible =
                                        !_isConfirmPasswordVisible;
                                  });
                                },
                                onChanged: _validateConfirmPassword,
                                isConfirmField: true,
                              ),

                              const SizedBox(height: 40),

                              // Set Password Button
                              _buildSetPasswordButton(),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Wave Decoration
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 0),
            painter: BottomWavePainter(),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FFFE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0F2F1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // 'Password Requirements:',
            AppLocalizations.of(context).translate("password_requirements"),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C5F5F),
            ),
          ),
          const SizedBox(height: 8),
          _buildRequirementItem(
              AppLocalizations.of(context).translate("at_least_8_chars"),
              _hasMinLength),
          _buildRequirementItem(
              AppLocalizations.of(context).translate("contains_uppercase"),
              _hasUppercase),
          _buildRequirementItem(
              AppLocalizations.of(context).translate("contains_special_char"),
              _hasSpecialChar),
          _buildRequirementItem(
              AppLocalizations.of(context).translate("passwords_match"),
              _passwordsMatch),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isValid ? const Color(0xFF4CAF50) : const Color(0xFFBDBDBD),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color:
                  isValid ? const Color(0xFF4CAF50) : const Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
    required Function(String) onChanged,
    bool isConfirmField = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F8F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0F2F1),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: !isVisible,
        style: GoogleFonts.poppins().copyWith(
          color: AppColors.primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText:
              AppLocalizations.of(context).translate("enter_your_password"),
          hintStyle: GoogleFonts.poppins().copyWith(
            color: const Color(0xFF7F909F),
            fontSize: 12,
            fontWeight: FontWeight.w200,
          ),
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: Color(0xFFE57373),
            size: 20,
          ),
          suffixIcon: IconButton(
            icon: Icon(
                isVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xFF797979)),
            onPressed: onVisibilityToggle,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)
                .translate("please_enter_password");
          }
          if (isConfirmField) {
            if (value != _passwordController.text) {
              return AppLocalizations.of(context)
                  .translate("passwords_do_not_match");
            }
          } else {
            if (value.length < 8) {
              return AppLocalizations.of(context)
                  .translate("password_min_length");
            }
            // if (!value.contains(RegExp(r'[A-Z]'))) {
            //   return AppLocalizations.of(context)
            //       .translate("password_uppercase");
            // }
            // if (!value.contains(RegExp(r'[!@#$%^&*(),.?\":{}|<>]'))) {
            //   return AppLocalizations.of(context)
            //       .translate("password_special_char");
            // }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSetPasswordButton() {
    bool isFormValid =
        _hasMinLength && _passwordsMatch;

    return Center(
      child: ElevatedButton(
        onPressed: (_isLoading || !isFormValid) ? null : _handleSetPassword,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isFormValid ? const Color(0xFF4A9FB0) : const Color(0xFFBDBDBD),
          foregroundColor: Colors.white,
          elevation: isFormValid ? 4 : 0,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: _isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    // 'Setting Password...',

                    AppLocalizations.of(context).translate("setting_password"),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Text(
                // 'Set New Password',
                AppLocalizations.of(context).translate("set_new_password"),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  void _handleSetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      ResetPasswordCubit.get(context).changePassword(
        confirmPassword: _confirmPasswordController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }
}

class BottomWaveDecorationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x846DAEB8)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.2,
      size.width * 0.5,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.6,
      size.width,
      size.height * 0.3,
    );
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
