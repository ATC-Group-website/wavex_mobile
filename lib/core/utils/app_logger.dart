import 'dart:developer' as developer;

/// Sends diagnostic messages to the platform developer log without relying on
/// `print` in production code.
void appLog(Object? message) {
  developer.log(message?.toString() ?? 'null');
}
