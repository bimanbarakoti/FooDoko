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
        title: Text("Your Cart", style: GoogleFonts.poppins()),
        backgroundColor: AppColors.deepMidnight,
      ),
      body: cartItems.isEmpty
          ? Center(
        child: Text(
          "Your cart is empty",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      )
          : ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];

          return Card(
            color: Colors.white12,
            margin: const EdgeInsets.all(10),
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
                "\$${item.item.price.toStringAsFixed(2)}",
                style: GoogleFonts.inter(color: Colors.white70),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.white),
                    onPressed: () =>
                        ref.read(cartProvider.notifier).decreaseQuantity(item),
                  ),
                  Text(
                    item.quantity.toString(),
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () =>
                        ref.read(cartProvider.notifier).addToCart(item.item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        ref.read(cartProvider.notifier).remove(item),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.white12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total: \$${total.toStringAsFixed(2)}",
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/payment');
              },
              child: const Text("Checkout"),
            )
          ],
        ),
      ),
    );
  }
}
