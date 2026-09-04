import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'package:wavex/core/theme/colors.dart';
import 'package:wavex/features/change_password_screen/logic/change_password_cubit.dart';
import '../../../../core/components/bottom_navigation_bar.dart';
import '../../../../core/components/bottom_wave_painter.dart';
import '../../../../core/components/custom_password_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePassword() {
    // Handle password update logic
    if(_formKey.currentState!.validate()){
      if (_newPasswordController.text.trim() !=
          _confirmPasswordController.text.trim()) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Confirm Password not same password'),
              backgroundColor: Colors.red,
            ),
          );
      } else {
        ChangePasswordCubit.get(context).changePassword(
          confirmPassword: _confirmPasswordController.text.trim(),
          password: _newPasswordController.text.trim(),
        );
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Wave background at bottom

          // Main content
          Column(
            children: [
              HeaderWidget(
                isWithBack: true,
              ),
              BlocListener<ChangePasswordCubit, ChangePasswordState>(
                listener: (context, state) {
                  if (state is ChangePasswordSuccessState) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text('Password updated successfully!'),
                          backgroundColor: Color(0xFF4DB6AC),
                        ),
                      );
                  }
                  if (state is ChangePasswordErrorState) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                          backgroundColor: Colors.red,
                        ),
                      );
                  }
                },
                child: const SizedBox.shrink(),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title with icon
                          Row(
                            children: [
                              Image.asset("assets/images/water_drop_icon.png"),
                              const SizedBox(width: 12),
                              Text(
                                'Change Password',
                                style: GoogleFonts.inter().copyWith(
                                  color: const Color(0xFF4DB6AC),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Current Password Field
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                                color: const Color(0xffEDF7F9),
                                borderRadius: BorderRadius.circular(20)),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // New Password Field
                                  Text(
                                    'New Password',
                                    style: GoogleFonts.leagueSpartan().copyWith(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  CustomPasswordField(
                                    controller: _newPasswordController,
                                    hintText: '••••••••••••••',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Password is required';
                                      }
                                      if (value.length < 8) {
                                        return 'Password must be at least 8 characters';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 24),

                                  // Confirm New Password Field
                                  Text(
                                    'Confirm New Password',
                                    style: GoogleFonts.leagueSpartan().copyWith(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  CustomPasswordField(
                                    controller: _confirmPasswordController,
                                    hintText: '••••••••••••••',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      }
                                      if (value != _newPasswordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // const Spacer(),

                          const SizedBox(
                            height: 30,
                          ),

                          // Update Password Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _updatePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: Text('Update Password',
                                  style: GoogleFonts.inter().copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
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
  }
}
