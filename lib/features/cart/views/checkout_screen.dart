// lib/features/cart/views/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../app/config/app_colors.dart';
import '../../../app/services/biometric_service.dart';
import '../providers/cart_providers.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> with TickerProviderStateMixin {
  late AnimationController _aiController;
  late AnimationController _pulseController;
  
  String _selectedPaymentMethod = 'card';
  final String _deliveryAddress = '123 Main St, City, State 12345';
  bool _isProcessing = false;

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

  Future<void> _processOrder() async {
    final cart = ref.read(cartProvider);
    
    setState(() => _isProcessing = true);
    
    // Biometric authentication for payment
    if (_selectedPaymentMethod == 'biometric') {
      final isAuthenticated = await BiometricService.authenticateForPayment(cart.total);
      if (!isAuthenticated) {
        setState(() => _isProcessing = false);
        return;
      }
    }
    
    // Simulate order processing
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      // Clear cart
      ref.read(cartProvider.notifier).clearCart();
      
      // Show success and navigate
      _showOrderSuccess();
    }
    
    setState(() => _isProcessing = false);
  }

  void _showOrderSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
              child: const Icon(Icons.check, size: 40, color: Colors.white),
            ).animate().scale(delay: 200.ms),
            
            const SizedBox(height: 20),
            
            Text(
              'Order Placed Successfully!',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 400.ms),
            
            const SizedBox(height: 12),
            
            Text(
              'Your delicious food is being prepared with love!',
              style: GoogleFonts.inter(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 600.ms),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/tracking');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.electricGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Track Order',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ).animate().slideY(delay: 800.ms, begin: 0.3).fadeIn(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Delivery Optimization
            Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        'AI Delivery Optimization',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildOptimizationItem('🚀 Route', 'Optimized'),
                      ),
                      Expanded(
                        child: _buildOptimizationItem('⏱️ Time', '25-30 min'),
                      ),
                      Expanded(
                        child: _buildOptimizationItem('🌱 Carbon', '2.3kg saved'),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().slideY(delay: 200.ms, begin: -0.2).fadeIn(),

            const SizedBox(height: 24),

            // Delivery Address
            _buildSection(
              title: 'Delivery Address',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.electricGreen),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Home',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).textTheme.titleMedium?.color,
                            ),
                          ),
                          Text(
                            _deliveryAddress,
                            style: GoogleFonts.inter(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Change address
                      },
                      child: Text(
                        'Change',
                        style: GoogleFonts.inter(color: AppColors.electricGreen),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().slideX(delay: 400.ms, begin: -0.3).fadeIn(),

            const SizedBox(height: 24),

            // Delivery Instructions
            _buildSection(
              title: 'Delivery Instructions',
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: (value) {
                    // Store delivery instructions
                  },
                  decoration: InputDecoration(
                    hintText: 'Add delivery instructions (optional)',
                    hintStyle: GoogleFonts.inter(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  maxLines: 3,
                ),
              ),
            ).animate().slideX(delay: 600.ms, begin: 0.3).fadeIn(),

            const SizedBox(height: 24),

            // Payment Method
            _buildSection(
              title: 'Payment Method',
              child: Column(
                children: [
                  _buildPaymentOption(
                    'card',
                    'Credit/Debit Card',
                    Icons.credit_card,
                    '**** **** **** 1234',
                  ),
                  _buildPaymentOption(
                    'biometric',
                    'Biometric Payment',
                    Icons.fingerprint,
                    'Ultra secure biometric authentication',
                  ),
                  _buildPaymentOption(
                    'wallet',
                    'Digital Wallet',
                    Icons.account_balance_wallet,
                    'Apple Pay, Google Pay',
                  ),
                ],
              ),
            ).animate().slideY(delay: 800.ms, begin: 0.2).fadeIn(),

            const SizedBox(height: 24),

            // Order Summary
            _buildSection(
              title: 'Order Summary',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ...cart.items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            '${item.quantity}x',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              color: AppColors.electricGreen,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.name,
                              style: GoogleFonts.inter(
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              ),
                            ),
                          ),
                          Text(
                            '\$${item.totalPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    )),
                    const Divider(),
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
              ),
            ).animate().slideY(delay: 1000.ms, begin: 0.2).fadeIn(),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: _isProcessing ? 1.0 + (_pulseController.value * 0.05) : 1.0,
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
                    onPressed: _isProcessing ? null : _processOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isProcessing
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Processing Order...',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Place Order • \$${cart.total.toStringAsFixed(2)}',
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
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildOptimizationItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: AppColors.electricGreen,
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
    );
  }

  Widget _buildPaymentOption(String value, String title, IconData icon, String subtitle) {
    final isSelected = _selectedPaymentMethod == value;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.electricGreen : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.electricGreen : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedPaymentMethod,
              onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
              activeColor: AppColors.electricGreen,
            ),
          ],
        ),
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