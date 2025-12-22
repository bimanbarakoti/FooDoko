// lib/features/restaurant/views/restaurant_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:badges/badges.dart' as badges;

import '../../../app/config/app_colors.dart';
import '../../cart/providers/cart_providers.dart';
import '../../ai/providers/ultra_ai_providers.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  final String restaurantId;
  
  const RestaurantScreen({super.key, required this.restaurantId});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> with TickerProviderStateMixin {
  late AnimationController _arController;
  late AnimationController _aiController;
  bool _arMode = false;

  final List<Map<String, dynamic>> _menuItems = [
    {
      'id': 'margherita_pizza',
      'name': 'Margherita Pizza',
      'description': 'Fresh mozzarella, tomato sauce, basil',
      'price': 18.99,
      'category': 'Pizza',
      'imageUrl': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
      'rating': 4.8,
      'calories': 320,
      'prepTime': '15-20 min',
      'isPopular': true,
      'aiRecommended': true,
    },
    {
      'id': 'pepperoni_pizza',
      'name': 'Pepperoni Pizza',
      'description': 'Classic pepperoni with mozzarella cheese',
      'price': 21.99,
      'category': 'Pizza',
      'imageUrl': 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400',
      'rating': 4.7,
      'calories': 380,
      'prepTime': '15-20 min',
      'isPopular': true,
    },
    {
      'id': 'veggie_supreme',
      'name': 'Veggie Supreme',
      'description': 'Bell peppers, mushrooms, olives, onions',
      'price': 19.99,
      'category': 'Pizza',
      'imageUrl': 'https://images.unsplash.com/photo-1571407970349-bc81e7e96d47?w=400',
      'rating': 4.6,
      'calories': 290,
      'prepTime': '15-20 min',
      'aiRecommended': true,
    },
    {
      'id': 'caesar_salad',
      'name': 'Caesar Salad',
      'description': 'Crisp romaine, parmesan, croutons',
      'price': 12.99,
      'category': 'Salads',
      'imageUrl': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
      'rating': 4.5,
      'calories': 180,
      'prepTime': '5-10 min',
    },
  ];

  @override
  void initState() {
    super.initState();
    _arController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _aiController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _arController.dispose();
    _aiController.dispose();
    super.dispose();
  }

  void _toggleARMode() {
    setState(() => _arMode = !_arMode);
    _arController.forward().then((_) => _arController.reverse());
  }

  void _addToCart(Map<String, dynamic> item) {
    final cartItem = CartItem(
      id: item['id'],
      name: item['name'],
      price: item['price'].toDouble(),
      imageUrl: item['imageUrl'],
      restaurantId: widget.restaurantId,
      restaurantName: 'Pizza Palace',
    );
    
    ref.read(cartProvider.notifier).addItem(cartItem);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['name']} added to cart!'),
        backgroundColor: AppColors.electricGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final aiState = ref.watch(ultraAIProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Restaurant Header with AR
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pizza Palace',
                                    style: GoogleFonts.poppins(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        '4.8 • Italian • 25-35 min',
                                        style: GoogleFonts.inter(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // AR Toggle
                            GestureDetector(
                              onTap: _toggleARMode,
                              child: AnimatedBuilder(
                                animation: _arController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: 1.0 + (_arController.value * 0.2),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: _arMode ? Colors.white : Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Icon(
                                        Icons.view_in_ar,
                                        color: _arMode ? AppColors.electricGreen : Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        if (_arMode) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.view_in_ar, color: AppColors.electricGreen, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'AR Mode Active - Point camera at menu items',
                                  style: GoogleFonts.inter(
                                    color: AppColors.electricGreen,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ).animate().slideY(begin: -0.3).fadeIn(),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              badges.Badge(
                badgeContent: Text(
                  cartItems.items.length.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                showBadge: cartItems.items.isNotEmpty,
                child: IconButton(
                  onPressed: () => context.push('/cart'),
                  icon: const Icon(Icons.shopping_basket, color: Colors.white),
                ),
              ),
            ],
          ),

          // AI Recommendations Section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
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
                        'AI Recommendations for You',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Based on your mood: ${aiState.currentMood} • Weather: ${aiState.currentWeather}',
                    style: GoogleFonts.inter(
                      color: AppColors.electricGreen,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ).animate().slideY(delay: 200.ms, begin: -0.2).fadeIn(),
          ),

          // Menu Categories
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryChip('All', true),
                  _buildCategoryChip('Pizza', false),
                  _buildCategoryChip('Salads', false),
                  _buildCategoryChip('Drinks', false),
                  _buildCategoryChip('Desserts', false),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Menu Items
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = _menuItems[index];
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item Image with AR overlay
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: Image.network(
                              item['imageUrl'],
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.fastfood, size: 60, color: Colors.white),
                                  ),
                                );
                              },
                            ),
                          ),
                          
                          // Badges
                          Positioned(
                            top: 12,
                            left: 12,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  if (item['isPopular'] == true)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Popular',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  if (item['aiRecommended'] == true) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [AppColors.electricGreen, Colors.blue],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'AI Pick',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          
                          if (_arMode)
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.view_in_ar, color: AppColors.electricGreen, size: 20),
                              ),
                            ),
                        ],
                      ),
                      
                      // Item Details
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item['name'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).textTheme.titleLarge?.color,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '\$${item['price'].toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.electricGreen,
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 8),
                            
                            Text(
                              item['description'],
                              style: GoogleFonts.inter(
                                color: Colors.grey,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            
                            const SizedBox(height: 12),
                            
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${item['rating']}',
                                    style: GoogleFonts.inter(fontSize: 12),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(Icons.local_fire_department, color: Colors.orange, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${item['calories']} cal',
                                    style: GoogleFonts.inter(fontSize: 12),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(Icons.access_time, color: Colors.grey, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    item['prepTime'],
                                    style: GoogleFonts.inter(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Add to Cart Button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () => _addToCart(item),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.electricGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.add_shopping_cart, color: Colors.white),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Add to Cart',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: (index * 100).ms).slideY(begin: 0.3).fadeIn();
              },
              childCount: _menuItems.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // Handle category selection
        },
        backgroundColor: Colors.grey.withValues(alpha: 0.1),
        selectedColor: AppColors.electricGreen.withValues(alpha: 0.2),
        labelStyle: GoogleFonts.inter(
          color: isSelected ? AppColors.electricGreen : Colors.grey,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected ? AppColors.electricGreen : Colors.grey.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}