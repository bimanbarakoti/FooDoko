// lib/app/services/biometric_service.dart
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricService {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  static Future<bool> isAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  static Future<bool> authenticate({
    String localizedReason = 'Authenticate to access FooDoko',
    bool useErrorDialogs = true,
    bool stickyAuth = false,
  }) async {
    try {
      final isAvailable = await BiometricService.isAvailable();
      if (!isAvailable) return false;

      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          biometricOnly: true,
        ),
      );

      return isAuthenticated;
    } on PlatformException catch (e) {
      print('Biometric authentication error: ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected biometric error: $e');
      return false;
    }
  }

  static Future<bool> authenticateForPayment(double amount) async {
    return await authenticate(
      localizedReason: 'Authenticate to complete payment of \$${amount.toStringAsFixed(2)}',
      useErrorDialogs: true,
      stickyAuth: true,
    );
  }

  static Future<bool> authenticateForSettings() async {
    return await authenticate(
      localizedReason: 'Authenticate to access sensitive settings',
      useErrorDialogs: true,
      stickyAuth: false,
    );
  }

  static String getBiometricTypeString(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.iris:
        return 'Iris';
      case BiometricType.strong:
        return 'Strong Biometric';
      case BiometricType.weak:
        return 'Weak Biometric';
      default:
        return 'Biometric';
    }
  }
}