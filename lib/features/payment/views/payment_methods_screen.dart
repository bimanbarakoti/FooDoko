// lib/features/payment/views/payment_methods_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/config/app_colors.dart';
import 'package:foodoko/features/cart/providers/cart_providers.dart';

class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartItemsProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      backgroundColor: AppColors.deepMidnight,
      appBar: AppBar(
        backgroundColor: AppColors.deepMidnight,
        title: Text('Payment', style: GoogleFonts.poppins(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "Order Summary",
            style: GoogleFonts.poppins(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // CART ITEMS LIST
          ...items.map(
                (item) => Card(
              color: Colors.white12,
              child: ListTile(
                leading: Image.network(
                  item.item.imageUrl,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  item.item.name,
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                subtitle: Text(
                  "x${item.quantity}   \$${item.totalPrice.toStringAsFixed(2)}",
                  style: GoogleFonts.inter(color: Colors.white70),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          Divider(color: Colors.white24),

          // TOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "\$${total.toStringAsFixed(2)}",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          Text(
            "Select Payment Method",
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),

          _paymentTile("Cash on Delivery", Icons.money),
          _paymentTile("Khalti", Icons.account_balance_wallet),
          _paymentTile("eSewa", Icons.phone_android),
          _paymentTile("Card (Visa / Mastercard)", Icons.credit_card),
        ],
      ),
    );
  }

  Widget _paymentTile(String title, IconData icon) {
    return Card(
      color: Colors.white12,
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: GoogleFonts.poppins(color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
        onTap: () {},
      ),
    );
  }
}
