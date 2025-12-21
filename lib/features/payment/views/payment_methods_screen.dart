// lib/features/payment/views/payment_methods_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../app/config/app_colors.dart';
import 'package:foodoko/features/cart/providers/cart_providers.dart';
import '../services/khalti_service.dart';

class PaymentMethodsScreen extends ConsumerStatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  ConsumerState<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
  bool _isProcessing = false;

  void _handleKhaltiPayment() async {
    final items = ref.read(cartItemsProvider);
    final total = ref.read(cartTotalProvider);
    
    if (items.isEmpty) {
      _showSnackBar('Cart is empty!');
      return;
    }

    setState(() => _isProcessing = true);

    await KhaltiService.makePayment(
      context: context,
      amount: total,
      productName: 'FooDoko Order',
      productId: 'order_${DateTime.now().millisecondsSinceEpoch}',
      onSuccess: (PaymentSuccessModel success) async {
        setState(() => _isProcessing = false);
        
        // Verify payment
        final verified = await KhaltiService.verifyPayment(
          token: success.token,
          amount: total,
        );
        
        if (verified) {
          // Clear cart
          ref.read(cartNotifierProvider.notifier).clearCart();
          
          _showSuccessDialog(success);
        } else {
          _showSnackBar('Payment verification failed');
        }
      },
      onFailure: (PaymentFailureModel failure) {
        setState(() => _isProcessing = false);
        _showSnackBar('Payment failed: ${failure.message}');
      },
      onCancel: () {
        setState(() => _isProcessing = false);
        _showSnackBar('Payment cancelled');
      },
    );
  }

  void _handleCashOnDelivery() {
    final items = ref.read(cartItemsProvider);
    
    if (items.isEmpty) {
      _showSnackBar('Cart is empty!');
      return;
    }

    // Clear cart and show success
    ref.read(cartNotifierProvider.notifier).clearCart();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text('Order Placed!', style: GoogleFonts.poppins(color: Colors.white)),
        content: Text(
          'Your order has been placed successfully. Pay cash when delivered.',
          style: GoogleFonts.inter(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/home');
            },
            child: Text('OK', style: TextStyle(color: AppColors.electricGreen)),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(PaymentSuccessModel success) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text('Payment Successful!', style: GoogleFonts.poppins(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Transaction ID: ${success.token}', style: GoogleFonts.inter(color: Colors.white70)),
            const SizedBox(height: 8),
            Text('Amount: \$${(success.amount / 100).toStringAsFixed(2)}', style: GoogleFonts.inter(color: Colors.white70)),
            const SizedBox(height: 8),
            Text('Your order is being prepared!', style: GoogleFonts.inter(color: Colors.white70)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/home');
            },
            child: Text('OK', style: TextStyle(color: AppColors.electricGreen)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.surfaceDark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(cartItemsProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      backgroundColor: AppColors.deepMidnight,
      appBar: AppBar(
        backgroundColor: AppColors.deepMidnight,
        title: Text('Payment', style: GoogleFonts.poppins(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isProcessing
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.electricGreen),
            )
          : ListView(
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
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.item.imageUrl,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 60,
                              width: 60,
                              color: Colors.grey,
                              child: const Icon(Icons.fastfood, color: Colors.white),
                            );
                          },
                        ),
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
                const Divider(color: Colors.white24),

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
                        color: AppColors.electricGreen,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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

                _paymentTile(
                  "Cash on Delivery", 
                  Icons.money, 
                  _handleCashOnDelivery,
                ),
                _paymentTile(
                  "Khalti Digital Wallet", 
                  Icons.account_balance_wallet, 
                  _handleKhaltiPayment,
                ),
                _paymentTile(
                  "eSewa (Coming Soon)", 
                  Icons.phone_android, 
                  () => _showSnackBar('eSewa integration coming soon!'),
                ),
                _paymentTile(
                  "Card Payment (Coming Soon)", 
                  Icons.credit_card, 
                  () => _showSnackBar('Card payment coming soon!'),
                ),
              ],
            ),
    );
  }

  Widget _paymentTile(String title, IconData icon, VoidCallback onTap) {
    return Card(
      color: Colors.white12,
      child: ListTile(
        leading: Icon(icon, color: AppColors.electricGreen),
        title: Text(title, style: GoogleFonts.poppins(color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
        onTap: onTap,
      ),
    );
  }
}
