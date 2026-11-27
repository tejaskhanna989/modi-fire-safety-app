import 'app_mode.dart';

/// Compile-time configuration. Change here only with explicit approval.
class AppConfig {
  const AppConfig._();

  static const String appName = 'Modi Fire Safety';
  static const String companyName = 'Modi International';
  static const String packageName = 'com.modifire.safety.demo';

  /// Phase 1 always runs in demo mode. Live integrations are disabled until
  /// real endpoints and credentials are supplied.
  static const AppMode mode = AppMode.demo;

  /// Demo checkout never contacts a payment gateway.
  static const bool checkoutIsSimulated = true;

  /// AI assistant uses a deterministic local rule engine in demo mode.
  static const bool assistantIsSimulated = true;

  /// QR scanning / generation are bundled locally when enabled in Phase 4.
  static const bool qrIsSimulated = true;

  static const String demoNotice =
      'Demo mode — data shown on this device is illustrative only.';
}
