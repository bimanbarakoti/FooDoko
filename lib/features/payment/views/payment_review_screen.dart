import 'package:flutter/material.dart';

class PaymentReviewScreen extends StatelessWidget {
  final String address;
  final String deliveryTime;
  final double totalAmount;

  const PaymentReviewScreen({
    super.key,
    required this.address,
    required this.deliveryTime,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Review Order")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Delivery Address: $address"),
            Text("Delivery Time: $deliveryTime"),
            Text("Total Amount: ₹${totalAmount.toStringAsFixed(2)}"),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/payment");
              },
              child: const Text("Confirm & Pay"),
            ),
          ],
        ),
      ),
    );
  }
}
