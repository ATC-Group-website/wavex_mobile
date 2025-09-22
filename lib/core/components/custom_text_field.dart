import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/theme/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final bool? enabled;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.enabled,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE2F2F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        enabled : enabled,
        keyboardType: keyboardType,
        style:  GoogleFonts.leagueSpartan().copyWith(
          fontSize: 20,
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.leagueSpartan().copyWith(
            fontSize: 18,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
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
}
