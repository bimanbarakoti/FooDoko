// lib/features/payment/services/khalti_service.dart
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:flutter/material.dart';

class KhaltiService {
  static const String publicKey = "test_public_key_dc74e0fd57cb46cd93832aee0a507256";
  
  static Future<void> initializeKhalti() async {
    // Khalti initialization is handled by KhaltiScope in main.dart
  }

  static Future<void> makePayment({
    required BuildContext context,
    required double amount,
    required String productName,
    required String productId,
    required Function(PaymentSuccessModel) onSuccess,
    required Function(PaymentFailureModel) onFailure,
    required Function() onCancel,
  }) async {
    try {
      final config = PaymentConfig(
        amount: (amount * 100).toInt(), // Convert to paisa
        productIdentity: productId,
        productName: productName,
        productUrl: 'https://foodoko.com/product/$productId',
        additionalData: {
          'vendor': 'FooDoko',
          'platform': 'mobile',
        },
      );

      KhaltiScope.of(context).pay(
        config: config,
        preferences: [
          PaymentPreference.khalti,
          PaymentPreference.eBanking,
          PaymentPreference.mobileBanking,
          PaymentPreference.connectIPS,
          PaymentPreference.sct,
        ],
        onSuccess: onSuccess,
        onFailure: onFailure,
        onCancel: onCancel,
      );
    } catch (e) {
      debugPrint('Khalti Payment Error: $e');
      onFailure(PaymentFailureModel(
        data: {},
        message: 'Payment initialization failed: $e',
      ));
    }
  }

  static Future<bool> verifyPayment({
    required String token,
    required double amount,
  }) async {
    try {
      // In a real app, you would verify the payment on your backend
      // This is just a mock verification
      await Future.delayed(const Duration(seconds: 2));
      return true;
    } catch (e) {
      debugPrint('Payment verification failed: $e');
      return false;
    }
  }
}