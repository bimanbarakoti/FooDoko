// lib/features/cart/views/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/config/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foodoko/features/cart/providers/cart_providers.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartItemsProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      backgroundColor: AppColors.deepMidnight,
      appBar: AppBar(
        title: Text("Your Cart", style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: AppColors.deepMidnight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (cartItems.isNotEmpty)
            TextButton(
              onPressed: () {
                ref.read(cartNotifierProvider.notifier).clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cart cleared'),
                    backgroundColor: AppColors.surfaceDark,
                  ),
                );
              },
              child: Text(
                'Clear All',
                style: GoogleFonts.inter(color: AppColors.electricGreen),
              ),
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Your cart is empty",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Add some delicious items to get started",
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.electricGreen,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text(
                      'Browse Restaurants',
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    color: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Item image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.item.imageUrl,
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 80,
                                  width: 80,
                                  color: Colors.grey,
                                  child: const Icon(Icons.fastfood, color: Colors.white),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          
                          // Item details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.item.name,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "\$${item.item.price.toStringAsFixed(2)} each",
                                  style: GoogleFonts.inter(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Total: \$${item.totalPrice.toStringAsFixed(2)}",
                                  style: GoogleFonts.poppins(
                                    color: AppColors.electricGreen,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Quantity controls
                          Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.remove, color: Colors.white, size: 16),
                                      onPressed: () => ref.read(cartNotifierProvider.notifier).decreaseQuantity(item),
                                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 12),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: AppColors.electricGreen,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      item.quantity.toString(),
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.add, color: Colors.white, size: 16),
                                      onPressed: () => ref.read(cartNotifierProvider.notifier).addToCart(item.item),
                                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                onPressed: () => ref.read(cartNotifierProvider.notifier).remove(item),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Amount",
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "\$${total.toStringAsFixed(2)}",
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () => context.push('/payment'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.electricGreen,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Proceed to Pay",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
