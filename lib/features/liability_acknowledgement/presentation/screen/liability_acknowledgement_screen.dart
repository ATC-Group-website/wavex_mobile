import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/app_localization.dart';
import 'package:wavex/core/constants/cache_keys.dart';
import 'package:wavex/core/helper/cache_helper/cache_helper.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';

class LiabilityAcknowledgementScreen extends StatefulWidget {
  const LiabilityAcknowledgementScreen({super.key});

  @override
  State<LiabilityAcknowledgementScreen> createState() =>
      _LiabilityAcknowledgementScreenState();
}

class _LiabilityAcknowledgementScreenState
    extends State<LiabilityAcknowledgementScreen> {
  static const _version = 'v1';
  bool _checkingAcknowledgement = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final acknowledgedVersion =
          CacheHelper.getdata(key: CacheKeys.waiverAcknowledgedVersion);
      if (acknowledgedVersion == _version) {
        _openBranches();
      } else {
        setState(() => _checkingAcknowledgement = false);
      }
    });
  }

  Future<void> _acknowledge() async {
    setState(() => _saving = true);
    final saved = await CacheHelper.saveData(
      key: CacheKeys.waiverAcknowledgedVersion,
      value: _version,
    );
    if (!mounted) return;
    if (!saved) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Could not save acknowledgement. Please try again.')));
      return;
    }
    _openBranches();
  }

  void _openBranches() {
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteStrings.branchSelectionScreen,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingAcknowledgement) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final localizations = AppLocalizations.of(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF17333A),
        body: SafeArea(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              constraints: const BoxConstraints(maxWidth: 520, maxHeight: 680),
              padding: const EdgeInsets.fromLTRB(28, 34, 28, 24),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: Column(
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: const BoxDecoration(
                        color: Color(0xFF062657), shape: BoxShape.circle),
                    child: const Icon(Icons.info_outline,
                        color: Colors.white, size: 54),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    localizations.translate('waiver_title'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontSize: 27, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        localizations.translate('waiver_body'),
                        style: GoogleFonts.inter(fontSize: 18, height: 1.35),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 52,
                    width: 154,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _acknowledge,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF062657),
                          foregroundColor: Colors.white),
                      child: _saving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5))
                          : Text(localizations.translate('waiver_ok'),
                              style: GoogleFonts.inter(
                                  fontSize: 20, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
