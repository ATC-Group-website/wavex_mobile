import 'package:flutter/material.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';
import 'package:wavex/main.dart';

import '../app_localization.dart';
import '../theme/colors.dart';

class LoginRequiredDialog extends StatelessWidget {
  const LoginRequiredDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(8)),
                      child: Icon(Icons.lock, color: Colors.amber.shade700, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      localizations.translate("login_required"),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.grey, size: 24),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(50)),
              child: Stack(
                children: [
                  Icon(Icons.person, size: 48, color: Colors.grey.shade600),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.grey.shade700, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.lock, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Main text
            Text(
              localizations.translate("login_required_message"),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Subtitle text
            Text(
              localizations.translate("login_required_subtitle"),
              style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade500,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Text(localizations.translate("cancel"), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  ),
                ),
                const SizedBox(width: 12),

                // Login button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => navigatorKey.currentState!.pushNamed(RouteStrings.loginScreen),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Text(localizations.translate("login"), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  ),
                ),
                const SizedBox(width: 12),

                // Sign Up button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => navigatorKey.currentState!.pushNamed(RouteStrings.registerStepOneScreen),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.teal,
                      side: BorderSide(color: AppColors.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(localizations.translate("sign_up"), style: const TextStyle(color: AppColors.primaryColor, fontSize: 15, fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

