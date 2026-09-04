import 'package:flutter_test/flutter_test.dart';
import 'package:wavex/features/liability_acknowledgement/presentation/widgets/waiver_consent_dialog.dart';

void main() {
  group('WaiverConsentDialog', () {
    test('requires consent when acknowledgement is missing or outdated', () {
      expect(WaiverConsentDialog.requiresConsent(null), isTrue);
      expect(WaiverConsentDialog.requiresConsent('v0'), isTrue);
    });

    test('does not require consent for the current waiver version', () {
      expect(WaiverConsentDialog.requiresConsent(WaiverConsentDialog.version),
          isFalse);
    });
  });
}
