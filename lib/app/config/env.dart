// lib/app/config/env.dart
class Env {
  Env._();

  /// Toggle switching for environment-specific behavior.
  /// Set to `true` for verbose mocks/logging during development.
  static const bool isDev = true;

  /// If you add remote config or different api base, configure here.
  static const String apiBaseUrlDev = 'https://mock-api.local';
  static const String apiBaseUrlProd = 'https://api.foodoko.com';

  static String get apiBaseUrl => isDev ? apiBaseUrlDev : apiBaseUrlProd;
}
