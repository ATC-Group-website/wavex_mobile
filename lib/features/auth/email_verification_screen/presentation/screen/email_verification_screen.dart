import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'package:wavex/core/helper/cache_helper/cache_helper.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';
import 'package:wavex/features/auth/password_reset_screen/logic/reset_password_cubit.dart';
import 'dart:async';

import '../../../../../core/app_localization.dart';
import '../../../../../core/components/bottom_wave_painter.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../main.dart';
import '../../../set_new_password_screen/presentation/screen/set_new_password_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  const EmailVerificationScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  bool _isLoading = false;
  int _resendTimer = 183; // 3:03 in seconds
  Timer? _timer;
  bool _canResend = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _startTimer();

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
    _codeController.dispose();
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _canResend = false;
    _resendTimer = 183; // 3:03
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with gradient
          HeaderWidget(
            isWithBack: true,
          ),

          BlocListener<ResetPasswordCubit, ResetPasswordState>(
            listener: (context, state) {
              if (state is VerifyOtpSuccessState) {

                CacheHelper.saveData(key: "userToken", value: state.verifyOTPResponse.data?.token??"");

                setState(() {
                  _isLoading = false;
                });

                // Show success and navigate to set new password
                ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context).translate("codeVerified"),
                    ),
                    backgroundColor: Color(0xFF4CAF50),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                navigatorKey.currentState!.pushNamed(
                  RouteStrings.setNewPasswordScreen,
                );
              }
              if(state is VerifyOtpErrorState){

                setState(() {
                  _isLoading = false;
                });

                ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                  SnackBar(
                    content: Text(
                      state.error??"",
                    ),
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
                                // 'Confirm Your Email',
                                AppLocalizations.of(context)
                                    .translate("confirmYourEmail"),
                                style: GoogleFonts.poppins().copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF666666),
                                    height: 1.5,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: AppLocalizations.of(context)
                                          .translate("verificationCodeSentTo")
                                          .replaceFirst(
                                            "{email}",
                                            widget.email,
                                          ),
                                      // 'We\'ve sent 5 digits verification code\nto ',
                                      style: GoogleFonts.poppins().copyWith(
                                        color: const Color(0xFF7F909F),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    // TextSpan(
                                    //   text: widget.email,
                                    //   style: GoogleFonts.poppins().copyWith(
                                    //     color: const Color(0xFFD70404),
                                    //     fontSize: 14,
                                    //     fontWeight: FontWeight.w400,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Verification Code Form
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // 'Enter Verification Code',
                                AppLocalizations.of(context)
                                    .translate("enterVerificationCode"),
                                style: GoogleFonts.poppins().copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildVerificationCodeField(),
                              const SizedBox(height: 40),
                              _buildVerifyButton(),
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

  Widget _buildVerificationCodeField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE2F2F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              maxLength: 5,
              style: GoogleFonts.poppins().copyWith(
                color: const Color(0xFF47A5B8),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(5),
              ],
              decoration: InputDecoration(
                hintText: '55155',
                hintStyle: GoogleFonts.poppins().copyWith(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                ),
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: Color(0xFFE57373),
                  size: 20,
                ),
                border: InputBorder.none,
                counterText: '',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  // return 'Please enter the verification code';
                  return AppLocalizations.of(context)
                      .translate("pleaseEnterCode");
                }
                if (value.length != 5) {
                  // return 'Please enter a 5-digit code';
                  return AppLocalizations.of(context)
                      .translate("pleaseEnter5Digits");
                }
                return null;
              },
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _canResend
                ? GestureDetector(
                    onTap: _handleResendCode,
                    child: Text(
                      // 'Resend',
                      AppLocalizations.of(context).translate("resend"),
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4ECDC4),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Text(
                    AppLocalizations.of(context)
                        .translate("resendIn")
                        .replaceFirst("{time}", _formatTime(_resendTimer)),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleVerifyCode,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A9FB0),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    // 'Verifying...',
                    AppLocalizations.of(context).translate("verifying"),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Text(
                // 'Verify and Set New Password',
                AppLocalizations.of(context)
                    .translate("verifyAndSetNewPassword"),
                style: GoogleFonts.poppins().copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  void _handleVerifyCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      // await Future.delayed(const Duration(seconds: 2));
      ResetPasswordCubit.get(context)
          .verifyOtp(otp: _codeController.text, email: widget.email);

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => const SetNewPasswordScreen()));

      print('Code verified: ${_codeController.text}');
      // Navigate to set new password screen
    }
  }

  void _handleResendCode() async {
    // Show loading state
    ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).translate("sendingNewCode")),
        backgroundColor: Color(0xFF4ECDC4),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );

    // Simulate API call
    // await Future.delayed(const Duration(seconds: 1));
    ResetPasswordCubit.get(context)
        .forgetPassword(email: widget.email);
    // Restart timer
    _startTimer();

    ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).translate("newCodeSent")),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
      ),
    );

    print('Resend code to: ${widget.email}');
  }
}

class EmailVerificationIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Background circle
    paint.color = const Color(0xFFF0F8F8);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.4,
      paint,
    );

    // Device/Card background
    paint.color = Colors.white;
    final cardRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width * 0.6,
        height: size.height * 0.4,
      ),
      const Radius.circular(12),
    );
    canvas.drawRRect(cardRect, paint);

    // Device shadow
    paint.color = Colors.black12;
    final shadowRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2 + 2, size.height / 2 + 2),
        width: size.width * 0.6,
        height: size.height * 0.4,
      ),
      const Radius.circular(12),
    );
    canvas.drawRRect(shadowRect, paint);
    canvas.drawRRect(cardRect, Paint()..color = Colors.white);

    // Teal accent elements
    paint.color = const Color(0xFF4ECDC4);

    // Top circle
    canvas.drawCircle(
      Offset(size.width * 0.4, size.height * 0.35),
      8,
      paint,
    );

    // Bottom circle
    canvas.drawCircle(
      Offset(size.width * 0.4, size.height * 0.65),
      8,
      paint,
    );

    // Central verification bar
    paint.color = const Color(0xFF2C5F5F);
    final barRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.35,
        size.height * 0.48,
        size.width * 0.3,
        size.height * 0.04,
      ),
      const Radius.circular(20),
    );
    canvas.drawRRect(barRect, paint);

    // Verification dots (representing code input)
    paint.color = Colors.white;
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(size.width * (0.37 + i * 0.04), size.height * 0.5),
        2,
        paint,
      );
    }

    // Right side circle
    paint.color = const Color(0xFF4ECDC4);
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.5), 6, paint);

    // Lines representing text
    paint.color = const Color(0xFFE0E0E0);
    paint.strokeWidth = 2;
    canvas.drawLine(
      Offset(size.width * 0.45, size.height * 0.38),
      Offset(size.width * 0.65, size.height * 0.38),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.45, size.height * 0.68),
      Offset(size.width * 0.65, size.height * 0.68),
      paint,
    );

    // Decorative crosses
    paint.color = const Color(0xFF4ECDC4).withOpacity(0.3);
    paint.strokeWidth = 1;

    // Top left cross
    canvas.drawLine(
      Offset(size.width * 0.15, size.height * 0.2),
      Offset(size.width * 0.2, size.height * 0.25),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.15, size.height * 0.25),
      paint,
    );

    // Bottom right cross
    canvas.drawLine(
      Offset(size.width * 0.8, size.height * 0.75),
      Offset(size.width * 0.85, size.height * 0.8),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.85, size.height * 0.75),
      Offset(size.width * 0.8, size.height * 0.8),
      paint,
    );

    // Arrow indicating direction/flow
    paint.color = const Color(0xFF4ECDC4).withOpacity(0.5);
    paint.strokeWidth = 2;
    canvas.drawLine(
      Offset(size.width * 0.85, size.height * 0.25),
      Offset(size.width * 0.9, size.height * 0.25),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.87, size.height * 0.22),
      Offset(size.width * 0.9, size.height * 0.25),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.87, size.height * 0.28),
      Offset(size.width * 0.9, size.height * 0.25),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
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
