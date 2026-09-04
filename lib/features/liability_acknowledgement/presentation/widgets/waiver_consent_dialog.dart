import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/app_localization.dart';
import 'package:wavex/core/constants/cache_keys.dart';
import 'package:wavex/core/helper/cache_helper/cache_helper.dart';
import 'package:wavex/core/theme/colors.dart';

/// Versioned, local consent gate shown on top of Home.
class WaiverConsentDialog extends StatefulWidget {
  const WaiverConsentDialog({super.key});

  static const version = 'v1';

  static bool requiresConsent(Object? savedVersion) => savedVersion != version;

  static Future<void> showIfRequired(BuildContext context) async {
    if (!requiresConsent(
        CacheHelper.getdata(key: CacheKeys.waiverAcknowledgedVersion))) {
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const WaiverConsentDialog(),
    );
  }

  @override
  State<WaiverConsentDialog> createState() => _WaiverConsentDialogState();
}

class _WaiverConsentDialogState extends State<WaiverConsentDialog> {
  bool _saving = false;
  String? _error;

  Future<void> _consent() async {
    setState(() {
      _saving = true;
      _error = null;
    });

    final saved = await CacheHelper.saveData(
      key: CacheKeys.waiverAcknowledgedVersion,
      value: WaiverConsentDialog.version,
    );
    if (!mounted) return;
    if (saved) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _saving = false;
      _error = 'Could not save your consent. Please try again.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 640),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
            child: Column(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.health_and_safety_outlined,
                      color: Colors.white, size: 30),
                ),
                const SizedBox(height: 16),
                Text(
                  strings.translate('waiver_title'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF234D58),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      strings.translate('waiver_body'),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 1.45,
                        color: const Color(0xFF355760),
                      ),
                    ),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: Colors.red.shade700)),
                ],
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _consent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(strings.translate('waiver_ok'),
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
