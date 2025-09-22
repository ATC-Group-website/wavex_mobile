import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wavex/config/fcm.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'package:wavex/core/helper/cache_helper/cache_helper.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';
import '../../../../../core/app_localization.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/components/bottom_wave_painter.dart';
import '../../../../../core/components/gradient_button.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../main.dart';
import '../../logic/registration_cubit.dart';

class RegisterStepTwoScreen extends StatefulWidget {
  const RegisterStepTwoScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.dop,
    required this.gender,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String dop;
  final String gender;

  @override
  State<RegisterStepTwoScreen> createState() => _RegisterStepTwoScreenState();
}

class _RegisterStepTwoScreenState extends State<RegisterStepTwoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _emergencyNumber = TextEditingController();
  final _medicalConditions = TextEditingController();

  bool _showPassword = false;
  bool _showConfirm = false;
  bool _agree = true;
  bool _submitting = false;

  final _picker = ImagePicker();
  File? _pickedImage;

  Future<String?> convertImageToBase64(File? pickedFile) async {
    if (pickedFile == null) return null;

    List<int> imageBytes = await pickedFile.readAsBytes();
    String base64String = base64Encode(imageBytes);
    print("Base64 String: $base64String");

    return base64String;
  }

  @override
  void initState() {
    // TODO: implement initState
    FCM.init();
    super.initState();
  }

  @override
  void dispose() {
    _password.dispose();
    _confirmPassword.dispose();
    _emergencyNumber.dispose();
    super.dispose();
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
    final loc = AppLocalizations.of(context);
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(
            isWithBack: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocListener<RegistrationCubit, RegistrationState>(
                      listener: (context, state) {
                        if (state is RegistrationSuccessState) {
                          setState(() => _submitting = false);
                          navigatorKey.currentState!
                              .pushNamed(RouteStrings.loginScreen);
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                  content: Text(
                                      state.registerResponse.message ?? ""),
                                  backgroundColor: const Color(0xFF26C6DA)),
                            );
                        }
                        if (state is RegistrationErrorState) {
                          setState(() => _submitting = false);
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                  content: Text(state.error ?? ""),
                                  backgroundColor: Colors.red),
                            );
                        }
                      },
                      child: SizedBox.shrink(),
                    ),

                    _label(loc.translate("password"), requiredMark: true),
                    const SizedBox(height: 8),
                    _passwordField(
                      controller: _password,
                      isVisible: _showPassword,
                      onToggle: () =>
                          setState(() => _showPassword = !_showPassword),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return loc.translate("password_required");
                        }
                        if (v.length < 8) {
                          return loc.translate("password_min_length");
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    _label(loc.translate("confirm_password"),
                        requiredMark: true),
                    const SizedBox(height: 8),
                    _passwordField(
                      controller: _confirmPassword,
                      isVisible: _showConfirm,
                      onToggle: () =>
                          setState(() => _showConfirm = !_showConfirm),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return loc.translate("confirm_password_required");
                        }
                        if (v != _password.text) {
                          return loc.translate("passwords_do_not_match");
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    //
                    _label(loc.translate("emergency_number"),
                        requiredMark: false),
                    const SizedBox(height: 8),
                    _roundedField(
                      controller: _emergencyNumber,
                      hint: loc.translate("emergency_number_hint"),
                      keyboard: TextInputType.phone,
                    ),
                    const SizedBox(height: 18),

                    _label(loc.translate("medical_conditions"),
                        requiredMark: false),
                    const SizedBox(height: 8),
                    _roundedField(
                      controller: _medicalConditions,
                      hint: loc.translate("medical_conditions_hint"),
                    ),
                    const SizedBox(height: 18),

                    Text(
                      loc.translate("upload_your_image"),
                      style: GoogleFonts.leagueSpartan().copyWith(
                        color: const Color(0xFF252525),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _uploadBox(loc),

                    const SizedBox(height: 16),

                    // Terms & Privacy
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => _agree = !_agree),
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: _agree ? Colors.red : Colors.grey,
                                  width: 2),
                              color: _agree ? Colors.red : Colors.transparent,
                            ),
                            child: _agree
                                ? const Icon(Icons.check,
                                    size: 16, color: Colors.white)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: loc.translate("terms_agree"),
                                    style: GoogleFonts.leagueSpartan().copyWith(
                                      color: const Color(0xFF252525),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  TextSpan(
                                    text: loc.translate("terms_of_use"),
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
                                    text: " ${loc.translate("and")} ",
                                    style: GoogleFonts.leagueSpartan().copyWith(
                                      color: const Color(0xFF252525),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  TextSpan(
                                    text: loc.translate("privacy_policy"),
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

                    const SizedBox(height: 22),

                    GradientButton(
                      text: loc.translate("sign_up"),
                      loading: _submitting,
                      onPressed: _handleSubmit,
                    ),

                    // const SizedBox(height: 28),
                    //
                    // Center(
                    //   child: Text(
                    //     loc.translate("or_sign_up_with"),
                    //     style: const TextStyle(color: Color(0xFF666666)),
                    //   ),
                    // ),
                    // const SizedBox(height: 16),
                    //
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     _circleIconButton(
                    //         icon: Icons.g_mobiledata,
                    //         onTap: () => _social("Google")),
                    //     const SizedBox(width: 16),
                    //     _circleIconButton(
                    //         icon: Icons.facebook,
                    //         onTap: () => _social("Facebook")),
                    //     const SizedBox(width: 16),
                    //     _circleIconButton(
                    //         icon: Icons.fingerprint,
                    //         onTap: () => _social("Biometric")),
                    //   ],
                    // ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          loc.translate("already_have_account"),
                          style: const TextStyle(color: Color(0xFF666666)),
                        ),
                        TextButton(
                          onPressed: () {
                            navigatorKey.currentState!
                                .pushNamed(RouteStrings.loginScreen);
                          },
                          child: Text(
                            loc.translate("login"),
                            style: const TextStyle(
                              color: Color(0xFF26C6DA),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
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

  Widget _label(String text, {bool requiredMark = false}) {
    return Row(
      children: [
        Text(
          text,
          style: GoogleFonts.leagueSpartan().copyWith(
            color: const Color(0xFF252525),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (requiredMark)
          const Text('  *',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _roundedField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboard,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: validator,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ).copyWith(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF7CA6B0)),
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
    String hintText = '************',
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE2F2F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: !isVisible,
        validator: validator,
        style: GoogleFonts.leagueSpartan().copyWith(
          color: AppColors.primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintText: hintText,
          hintStyle: GoogleFonts.leagueSpartan().copyWith(
            color: AppColors.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: IconButton(
            onPressed: onToggle,
            icon: Icon(
              isVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF8FA9AF),
            ),
          ),
        ),
      ),
    );
  }

  Widget _uploadBox(AppLocalizations loc) {
    return GestureDetector(
      onTap: _pickImage,
      child: DottedBorder(
        dashPattern: const [5, 4],
        color: const Color(0xFF7CC6D1),
        strokeWidth: 1.6,
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        child: Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: _pickedImage == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: AppColors.primaryColor, width: 2),
                      ),
                      child: const Icon(Icons.cloud_upload_outlined,
                          color: AppColors.primaryColor),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          loc.translate("click_here"),
                          style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.info_outline,
                            size: 16, color: AppColors.primaryColor),
                      ],
                    ),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(_pickedImage!,
                      fit: BoxFit.cover, width: double.infinity),
                ),
        ),
      ),
    );
  }

  Widget _circleIconButton(
      {required IconData icon, required VoidCallback onTap}) {
    return Container(
      width: 56,
      height: 56,
      decoration:
          const BoxDecoration(color: Color(0xFF26C6DA), shape: BoxShape.circle),
      child:
          IconButton(icon: Icon(icon, color: Colors.white), onPressed: onTap),
    );
  }

  Future<void> _pickImage() async {
    try {
      final img = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 1024,
        maxWidth: 1024,
        imageQuality: 85,
      );
      if (img != null) {
        setState(() => _pickedImage = File(img.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
              content: Text('Error picking image: $e'),
              backgroundColor: Colors.red),
        );
    }
  }

  Map<String, String> splitFullName(String fullName) {
    List<String> parts = fullName.trim().split(" ");

    String firstName = parts.isNotEmpty ? parts.first : "";
    String lastName = parts.length > 1 ? parts.sublist(1).join(" ") : "";

    return {
      "first_name": firstName,
      "last_name": lastName,
    };
  }

  Future<void> _handleSubmit() async {
    final loc = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;
    if (!_agree) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
              content: Text(loc.translate("agree_terms_error")),
              backgroundColor: Colors.red),
        );
      return;
    }
    setState(() => _submitting = true);
    // await Future.delayed(const Duration(seconds: 2));

    // String fullName = widget.fullName;
    // var result = splitFullName(fullName);
    String? base64Image = await convertImageToBase64(_pickedImage);
    RegistrationCubit.get(context).register(
      firstName: widget.firstName,
      lastName: widget.lastName,
      email: widget.email,
      gender: widget.gender,
      password: _password.text.trim(),
      dateOfBirth: widget.dop,
      phone: widget.phone ?? "",
      emergencyNumber: _emergencyNumber.text,
      medicalConditions: _medicalConditions.text,
      deviceToken: CacheHelper.getdata(key: "fcmToken"),
      image: base64Image,
    );

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //       content: Text(loc.translate("account_created_success")),
    //       backgroundColor: const Color(0xFF26C6DA)),
    // );
  }

  void _social(String provider) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
            content: Text(
                '$provider ${AppLocalizations.of(context).translate("sign_up_tapped")}'),
            backgroundColor: const Color(0xFF26C6DA)),
      );
  }
}
