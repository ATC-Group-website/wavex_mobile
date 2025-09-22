import 'package:flutter/material.dart';
import 'package:wavex/core/helper/cache_helper/cache_helper.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';
import 'package:wavex/main.dart';

import '../../../../../core/app_localization.dart';
import '../../../login_screen/presentation/screen/login_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (CacheHelper.getdata(key: "userToken") != null) {
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
          RouteStrings.homeScreen,
              (route) => false,
        );
      }
    });
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

    _animationController.forward();


  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4CC2DD), Color(0xD824717D), Color(0xC9174951)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),

                        // Logo Section
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              // WAVEX Logo
                              Image.asset("assets/images/wavex_logo.png"),

                              // Tagline
                               Text(
                                 AppLocalizations.of(context).translate("ride_the_wave"),
                                 textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                  height: 1.3,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 2,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 60),

                        // Welcome Message
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child:  Text(
                            AppLocalizations.of(context).translate("start_journey"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 21,
                                color: Color(0xFF124F59),
                                fontWeight: FontWeight.w600,
                                fontFamily: "Inter"),
                          ),
                        ),

                        const SizedBox(height: 80),

                        // Buttons Section
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Column(
                              children: [
                                // Log In Button
                                _buildAuthButton(
                                  text: AppLocalizations.of(context).translate("login"),
                                  backgroundColor: const Color(0xFF45A3B7),
                                  textColor: Colors.white,
                                  onPressed: () {
                                    // Navigate to login screen
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                    navigatorKey.currentState!
                                        .pushNamed(RouteStrings.loginScreen);
                                    print('Navigate to Login');
                                  },
                                ),

                                const SizedBox(height: 16),

                                // Sign Up Button
                                _buildAuthButton(
                                  text: AppLocalizations.of(context).translate("signup"),
                                  backgroundColor: const Color(0xFF52757B),
                                  textColor: Colors.white,
                                  onPressed: () {
                                    // Navigate to sign up screen
                                    navigatorKey.currentState!.pushNamed(
                                        RouteStrings.registerStepOneScreen);
                                    print('Navigate to Sign Up');
                                  },
                                ),

                                const SizedBox(height: 32),

                                // Continue as Guest
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to main app as guest
                                    navigatorKey.currentState!.pushNamedAndRemoveUntil(RouteStrings.homeScreen, (route) => false,);
                                    print('Continue as Guest');
                                  },
                                  child:  Text(
                                    AppLocalizations.of(context).translate("guest"),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
                                    ),
                                  ),
                                ),
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

              // Bottom Wave Decoration
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 60),
                painter: BottomWavePainter(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthButton({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 4,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path1 = Path();
    final path2 = Path();
    final path3 = Path();

    // First wave
    path1.moveTo(0, size.height * 0.3);
    path1.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.1,
      size.width * 0.5,
      size.height * 0.3,
    );
    path1.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.5,
      size.width,
      size.height * 0.3,
    );

    // Second wave
    path2.moveTo(0, size.height * 0.5);
    path2.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.3,
      size.width * 0.5,
      size.height * 0.5,
    );
    path2.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.7,
      size.width,
      size.height * 0.5,
    );

    // Third wave
    path3.moveTo(0, size.height * 0.7);
    path3.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.5,
      size.width * 0.5,
      size.height * 0.7,
    );
    path3.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.9,
      size.width,
      size.height * 0.7,
    );

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class BottomWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x846DAEB8).withOpacity(0.3)
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
