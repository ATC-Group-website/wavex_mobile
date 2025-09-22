import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';
import 'package:wavex/features/auth/password_reset_screen/logic/reset_password_cubit.dart';
import 'package:wavex/features/change_password_screen/logic/change_password_cubit.dart';

import '../../../../../core/app_localization.dart';
import '../../../../../core/components/bottom_wave_painter.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../main.dart';
import '../../../email_verification_screen/presentation/screen/email_verification_screen.dart';
import '../../../../../core/theme/colors.dart';

class PasswordResetScreen extends StatefulWidget {
  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _isEmailSent = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          HeaderWidget(
            isWithBack: true,
          ),

          BlocListener<ResetPasswordCubit, ResetPasswordState>(
            listener: (context, state) {
              if (state is ForgetPasswordSuccessState) {
                setState(() {
                  _isLoading = false;
                  _isEmailSent = true;
                });
                ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                  SnackBar(
                    content: Text(
                        '${AppLocalizations.of(context).translate("verification_sent_snackbar")} ${_emailController.text}'),
                    backgroundColor: const Color(0xFF4CAF50),
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const EmailVerificationScreen()));

                navigatorKey.currentState!.pushNamed(
                  RouteStrings.emailVerificationScreen,
                  arguments: {
                    "email": _emailController.text.trim(),
                  },
                );
              }
              if(state is ForgetPasswordErrorState){
                setState(() {
                  _isLoading = false;
                });
                ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                  SnackBar(
                    content: Text(state.error??""),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
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
                    children: [
                      Image.asset("assets/images/reset_password_logo.png"),

                      // Title and Description
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate("reset_password_title"),

                                style: GoogleFonts.poppins().copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                                // style: TextStyle(
                                //   fontSize: 28,
                                //   fontWeight: FontWeight.w700,
                                //   color: Color(0xFF4ECDC4),
                                // ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                AppLocalizations.of(context)
                                    .translate("reset_password_description"),
                                style: GoogleFonts.poppins().copyWith(
                                  color: const Color(0xFF7F909F),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Email Form
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // 'Email Address',
                                AppLocalizations.of(context)
                                    .translate("email_address"),
                                style: GoogleFonts.poppins().copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildEmailField(),
                              const SizedBox(height: 40),
                              _buildSendButton(),
                            ],
                          ),
                        ),
                      ),

                      if (_isEmailSent) ...[
                        const SizedBox(height: 30),
                        _buildSuccessMessage(),
                      ],

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

  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE2F2F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          fontSize: 16,
          color: const Color(0xFF47A5B8),
        ),
        decoration: InputDecoration(
          hintText:
              AppLocalizations.of(context).translate("enter_email_address"),
          hintStyle: const TextStyle(
            color: Color(0xFF47A5B8),
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.email_outlined,
            color: Color(0xFFE57373),
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            // return 'Please enter your email address';
            return AppLocalizations.of(context).translate("please_enter_email");
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            // return 'Please enter a valid email address';
            return AppLocalizations.of(context).translate("invalid_email");
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSendButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSendVerification,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A9FB0),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          foregroundColor: Colors.white,
          elevation: 4,
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
                    // 'Sending...',
                    AppLocalizations.of(context).translate("sending"),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Text(
                // 'Send Verification Code',
                AppLocalizations.of(context).translate("send_verification"),
                style: GoogleFonts.poppins().copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4CAF50),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Color(0xFF4CAF50),
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // 'Email Sent Successfully!',
                  AppLocalizations.of(context).translate("email_sent_success"),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  // 'Check your inbox for reset instructions.',
                  AppLocalizations.of(context).translate("check_inbox"),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF388E3C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleSendVerification() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      // await Future.delayed(const Duration(seconds: 2));

      ResetPasswordCubit.get(context)
          .forgetPassword(email: _emailController.text.trim());
      // Show success snackbar

      print('Verification code sent to: ${_emailController.text}');
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
