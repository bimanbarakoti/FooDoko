// lib/features/payment/services/khalti_service.dart
import 'package:flutter/material.dart';

class KhaltiService {
  static const String publicKey = "test_public_key_dc74e0fd57cb46cd93832aee0a507256";
  
  static Future<void> initializeKhalti() async {
    // Mock initialization
  }

  static Future<void> makePayment({
    required BuildContext context,
    required double amount,
    required String productName,
    required String productId,
    required Function(Map<String, dynamic>) onSuccess,
    required Function(String) onFailure,
    required Function() onCancel,
  }) async {
    try {
      // Show mock payment dialog
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Khalti Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Amount: Rs. ${(amount * 100).toInt()}'),
              Text('Product: $productName'),
              const SizedBox(height: 16),
              const Text('This is a demo payment. Click Pay to simulate success.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Pay'),
            ),
          ],
        ),
      );

      if (result == true) {
        // Simulate successful payment
        onSuccess({
          'token': 'demo_token_${DateTime.now().millisecondsSinceEpoch}',
          'amount': (amount * 100).toInt(),
        });
      } else {
        onCancel();
      }
    } catch (e) {
      onFailure('Payment failed: $e');
    }
  }

  static Future<bool> verifyPayment({
    required String token,
    required double amount,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}