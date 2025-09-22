// Gradient CTA button mimicking the design
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/theme/colors.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool loading;

  const GradientButton(
      {required this.text, required this.onPressed, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF37B4C6),
            AppColors.primaryColor
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(28)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: loading ? null : onPressed,
        child: SizedBox(
          height: 56,
          child: Center(
            child: loading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.4, color: Colors.white))
                : Text(
                    text,
                    style: GoogleFonts.leagueSpartan().copyWith(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
