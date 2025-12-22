// lib/features/cart/views/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../app/config/app_colors.dart';
import '../providers/cart_providers.dart';
import '../../ai/providers/ultra_ai_providers.dart';
import '../../../app/widgets/bottom_nav_bar.dart';
import '../../../app/services/error_service.dart';
import '../../../app/services/native_service.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> with TickerProviderStateMixin {
  late AnimationController _aiController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _aiController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _aiController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final nutritionData = ref.watch(nutritionOptimizationProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'FooDoko Smart Cart',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          if (cart.isNotEmpty)
            IconButton(
              onPressed: () {
                ref.read(cartProvider.notifier).clearCart();
              },
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: cart.isEmpty ? _buildEmptyCart() : _buildCartContent(cart, nutritionData),
      bottomNavigationBar: cart.isEmpty ? const BottomNavBar(currentIndex: 2) : null,
      bottomSheet: cart.isNotEmpty ? _buildCheckoutBar(cart) : null,
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.1),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.electricGreen.withValues(alpha: 0.2),
                        AppColors.accentLight.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.shopping_basket_outlined,
                    size: 60,
                    color: AppColors.electricGreen,
                  ),
                ),
              );
            },
          ).animate().scale(delay: 200.ms),
          
          const SizedBox(height: 24),
          
          Text(
            'Your cart is empty',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ).animate().fadeIn(delay: 400.ms),
          
          const SizedBox(height: 8),
          
          Text(
            'Add some delicious items to get started!',
            style: GoogleFonts.inter(
              color: Colors.grey,
            ),
          ).animate().fadeIn(delay: 600.ms),
          
          const SizedBox(height: 32),
          
          // AI Suggestions for empty cart
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.electricGreen.withValues(alpha: 0.1),
                  Colors.blue.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.electricGreen.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    AnimatedBuilder(
                      animation: _aiController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _aiController.value * 2 * 3.14159,
                          child: const Icon(
                            Icons.psychology,
                            color: AppColors.electricGreen,
                            size: 24,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'AI Recommendations',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickAddButton('🍕 Pizza', 'pizza'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildQuickAddButton('🍔 Burger', 'burger'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildQuickAddButton('🍣 Sushi', 'sushi'),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().slideY(delay: 800.ms, begin: 0.3).fadeIn(),
        ],
      ),
    );
  }

  Widget _buildCartContent(CartState cart, Map<String, dynamic>? nutritionData) {
    return CustomScrollView(
      slivers: [
        // AI Nutrition Analysis
        if (nutritionData != null)
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.withValues(alpha: 0.1),
                    Colors.blue.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.analytics, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'AI Nutrition Analysis',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${nutritionData['healthScore']}% Healthy',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildNutritionItem('Calories', '${nutritionData['calories']}', Colors.orange),
                      _buildNutritionItem('Protein', '${nutritionData['protein']}g', Colors.red),
                      _buildNutritionItem('Carbs', '${nutritionData['carbs']}g', Colors.blue),
                      _buildNutritionItem('Fat', '${nutritionData['fat']}g', Colors.purple),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nutritionData['suggestion'],
                    style: GoogleFonts.inter(
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ).animate().slideY(delay: 200.ms, begin: -0.2).fadeIn(),
          ),

        // Cart Items
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = cart.items[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Item Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.fastfood, color: Colors.white),
                            );
                          },
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Item Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).textTheme.titleMedium?.color,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.restaurantName,
                              style: GoogleFonts.inter(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${item.totalPrice.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: AppColors.electricGreen,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Quantity Controls
                      Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  ref.read(cartProvider.notifier).updateQuantity(
                                    item.id,
                                    item.quantity - 1,
                                  );
                                },
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.remove, size: 16),
                                ),
                              ),
                              
                              Container(
                                width: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  '${item.quantity}',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              
                              GestureDetector(
                                onTap: () {
                                  ref.read(cartProvider.notifier).updateQuantity(
                                    item.id,
                                    item.quantity + 1,
                                  );
                                },
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 8),
                          
                          GestureDetector(
                            onTap: () {
                              ref.read(cartProvider.notifier).removeItem(item.id);
                            },
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ).animate(delay: (index * 100).ms).slideX(begin: 0.3).fadeIn();
            },
            childCount: cart.items.length,
          ),
        ),

        // Order Summary
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Summary',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSummaryRow('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
                _buildSummaryRow('Delivery Fee', '\$${cart.deliveryFee.toStringAsFixed(2)}'),
                _buildSummaryRow('Service Fee', '\$${cart.serviceFee.toStringAsFixed(2)}'),
                if (cart.discount > 0)
                  _buildSummaryRow('Discount', '-\$${cart.discount.toStringAsFixed(2)}', color: Colors.green),
                const Divider(),
                _buildSummaryRow(
                  'Total',
                  '\$${cart.total.toStringAsFixed(2)}',
                  isTotal: true,
                ),
              ],
            ),
          ).animate().slideY(delay: 400.ms, begin: 0.2).fadeIn(),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildCheckoutBar(CartState cart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.electricGreen.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              context.push('/checkout');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Checkout • \$${cart.total.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAddButton(String label, String type) {
    return GestureDetector(
      onTap: () async {
        await NativeService.selectionHaptic();
        ref.read(cartProvider.notifier).addPopularItem(type);
        if (mounted) {
          ErrorService.showSuccess(context, '$label added to cart!');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? color, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: color ?? Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: isTotal ? 16 : 14,
              color: color ?? (isTotal ? AppColors.electricGreen : Theme.of(context).textTheme.bodyMedium?.color),
            ),
          ),
        ],
      ),
    );
  }
}