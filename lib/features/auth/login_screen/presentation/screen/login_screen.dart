import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'package:wavex/core/di/dependency_injection.dart';
import 'package:wavex/core/helper/cache_helper/cache_helper.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';
import 'package:wavex/features/auth/login_screen/logic/login_cubit.dart';
import 'package:wavex/main.dart';
import '../../../../../config/fcm.dart';
import '../../../../../core/app_localization.dart';
import '../../../../../core/components/bottom_wave_painter.dart';
import '../../../../../core/components/gradient_button.dart';
import '../../../../../core/constants/constants.dart';
import '../../../password_reset_screen/logic/reset_password_cubit.dart';
import '../../../password_reset_screen/presentation/screen/password_reset_screen.dart';
import '../../../../../core/theme/colors.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // final _emailController = TextEditingController();
  // final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
    FCM.init();
  }

  @override
  void dispose() {
    // _emailController.dispose();
    // _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
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
            onTap: () {
              navigatorKey.currentState!.pushNamed(RouteStrings.authScreen);
            },
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
                      BlocListener<LoginCubit, LoginState>(
                        listener: (context, state) {
                          if (state is LoginSuccessState) {
                            setState(() {
                              _isLoading = false;
                            });

                            CacheHelper.saveData(
                                key: "userToken",
                                value: state.loginResponse.token ?? "");
                            CacheHelper.saveData(
                                key: "userImage",
                                value: state.loginResponse.user?.image ?? "");
                            CacheHelper.saveData(
                                key: "userImage",
                                value: state.loginResponse.user?.image ?? "");
                            CacheHelper.saveData(
                                key: "userEmail",
                                value: state.loginResponse.user?.email ?? "");
                            CacheHelper.saveData(
                                key: "userPhone",
                                value: state.loginResponse.user?.phone ?? "");
                            CacheHelper.saveData(
                                key: "firstName",
                                value:
                                    state.loginResponse.user?.firstName ?? "");
                            CacheHelper.saveData(
                                key: "gender",
                                value: state.loginResponse.user?.gender ?? "");
                            CacheHelper.saveData(
                                key: "lastName",
                                value:
                                    state.loginResponse.user?.lastName ?? "");
                            CacheHelper.saveData(
                                key: "userName",
                                value:
                                    "${state.loginResponse.user?.firstName ?? ""} ${state.loginResponse.user?.lastName ?? ""}");
                            CacheHelper.saveData(
                                key: "userId",
                                value:
                                    state.loginResponse.user?.id.toString() ??
                                        "");

                            LoginCubit.get(context).emailController.clear();
                            LoginCubit.get(context).passwordController.clear();

                            navigatorKey.currentState!.pushNamedAndRemoveUntil(
                              RouteStrings.homeScreen,
                              (route) => false,
                            );
                            // Handle successful login
                            print('Login successful');
                            // Navigate to main app
                          } else if (state is LoginErrorState) {
                            // setState(() {
                            _isLoading = false; // بس وقف اللودينج
                            // });

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
                        child: SizedBox.shrink(),
                      ),

                      // Logo Section
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Center(
                          child: Column(
                            children: [
                              // WAVEX Logo
                              Image.asset("assets/images/wavex_logo.png"),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Form Fields
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Email Field
                              Text(
                                AppLocalizations.of(context).translate("email"),
                                style: GoogleFonts.leagueSpartan().copyWith(
                                  color: const Color(0xFF252525),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildEmailField(),

                              const SizedBox(height: 24),

                              // Password Field
                              Text(
                                AppLocalizations.of(context)
                                    .translate("password"),
                                style: GoogleFonts.leagueSpartan().copyWith(
                                  color: const Color(0xFF252525),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildPasswordField(),

                              const SizedBox(height: 16),

                              // Forgot Password
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    // Handle forgot password
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BlocProvider.value(
                                          value: getIt<ResetPasswordCubit>(),
                                          child: PasswordResetScreen(),
                                        ),
                                      ),
                                    );
                                    print('Forgot Password tapped');
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate("forget_password"),
                                    style: GoogleFonts.leagueSpartan().copyWith(
                                      color: const Color(0xFF4595A4),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 40),

                              // Login Button
                              // _buildLoginButton(),

                              // Gradient Sign Up button
                              GradientButton(
                                text: AppLocalizations.of(context)
                                    .translate("login"),
                                loading: _isLoading,
                                onPressed: _handleLogin,
                              ),
                              //
                              // const SizedBox(height: 40),
                              //
                              // // Social Login Section
                              // _buildSocialLoginSection(),

                              const SizedBox(height: 40),

                              // Sign Up Link
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigate to sign up
                                    navigatorKey.currentState!.pushNamed(
                                        RouteStrings.registerStepOneScreen);
                                    print('Navigate to Sign Up');
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF666666),
                                      ),
                                      children: [
                                        TextSpan(
                                          text: AppLocalizations.of(context)
                                              .translate("dont_have_account"),
                                          style: GoogleFonts.leagueSpartan()
                                              .copyWith(
                                            color: const Color(0xFF252525),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        TextSpan(
                                          text: AppLocalizations.of(context)
                                              .translate("sign_up"),
                                          style: GoogleFonts.leagueSpartan()
                                              .copyWith(
                                            color: AppColors.primaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          // style: TextStyle(
                                          //   color: Color(0xFF4E9BAA),
                                          //   fontWeight: FontWeight.w600,
                                          // ),
                                        ),
                                      ],
                                    ),
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
        controller: LoginCubit.get(context).emailController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.primaryColor,
        ),
        decoration: const InputDecoration(
          hintText: 'example@example.com',
          hintStyle: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context).translate("please_enter_email");
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return AppLocalizations.of(context).translate("invalid_email");
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE2F2F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: LoginCubit.get(context).passwordController,
        obscureText: !_isPasswordVisible,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF2C5F5F),
        ),
        decoration: InputDecoration(
          hintText: '••••••••••••••',
          hintStyle: const TextStyle(
            color: AppColors.primaryColor,
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)
                .translate("please_enter_password");
          }
          if (value.length < 6) {
            return AppLocalizations.of(context).translate("short_password");
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSocialLoginSection() {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context).translate("or_sign_up_with"),
          style: GoogleFonts.leagueSpartan().copyWith(
            color: const Color(0xFF252525),
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
          // style: TextStyle(
          //   fontSize: 14,
          //   color: Color(0xFF666666),
          // ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              icon: Icons.g_mobiledata,
              onTap: () => print('Google login'),
            ),
            const SizedBox(width: 16),
            _buildSocialButton(
              icon: Icons.facebook,
              onTap: () => print('Facebook login'),
            ),
            const SizedBox(width: 16),
            _buildSocialButton(
              icon: Icons.fingerprint,
              onTap: () => print('Biometric login'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: Color(0xFF4E9BAA),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      LoginCubit.get(context).login(
        email: LoginCubit.get(context).emailController.text,
        password: LoginCubit.get(context).passwordController.text,
        deviceToken: CacheHelper.getdata(key: "fcmToken").toString(),
        orderId: CacheHelper.getdata(key: "orderId"),
      );

      // Simulate login process
      // await Future.delayed(const Duration(seconds: 2));
    }
  }
}

class WaveLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4ECDC4)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path1 = Path();
    final path2 = Path();

    // First wave
    path1.moveTo(0, size.height * 0.4);
    path1.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.2,
      size.width * 0.5,
      size.height * 0.4,
    );
    path1.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.6,
      size.width,
      size.height * 0.4,
    );

    // Second wave
    path2.moveTo(0, size.height * 0.6);
    path2.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.4,
      size.width * 0.5,
      size.height * 0.6,
    );
    path2.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.8,
      size.width,
      size.height * 0.6,
    );

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
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
    path.lineTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.3,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.7,
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
