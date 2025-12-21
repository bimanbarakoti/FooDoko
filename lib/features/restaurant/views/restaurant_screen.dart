// lib/features/restaurant/views/restaurant_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../app/widgets/glass/frosted_container.dart';
import '../../restaurant/providers/restaurant_providers.dart';
import '../../../app/config/app_colors.dart';
import '../../cart/providers/cart_providers.dart';

class RestaurantScreen extends ConsumerWidget {
  final String restaurantId;
  const RestaurantScreen({super.key, required this.restaurantId});

  String _getRestaurantName(String id) {
    final restaurantNames = {
      'r1': 'Pizza Palace',
      'r2': 'Burger Junction', 
      'r3': 'Sakura Sushi',
      'r4': 'Taco Fiesta',
      'r5': 'Green Garden',
      'r6': 'Spice Route',
    };
    return restaurantNames[id] ?? 'Restaurant';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = ref.watch(menuSectionsProvider(restaurantId));
    final items = ref.watch(menuItemsProvider(restaurantId));
    final restaurantName = _getRestaurantName(restaurantId);

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantName, style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: AppColors.deepMidnight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/cart'),
            icon: const Icon(Icons.shopping_basket, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: AppColors.deepMidnight,
      body: sections.when(
        data: (secs) {
          return items.when(
            data: (its) {
              return ListView(
                children: [
                  // Restaurant header image
                  Container(
                    height: 200,
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: AppColors.primaryGradient,
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'https://picsum.photos/400/200?restaurant=$restaurantId',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: AppColors.primaryGradient,
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.restaurant, size: 50, color: Colors.white),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: FrostedContainer(
                            blur: 8,
                            borderRadius: BorderRadius.circular(12),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  restaurantName,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      '4.5 • 25-35 min • \$\$',
                                      style: GoogleFonts.inter(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Menu sections
                  ...secs.map((s) {
                    final sectionItems = its.where((i) => s.itemIds.contains(i.id)).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Text(
                            s.title,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ),

                        // Menu items
                        ...sectionItems.map(
                          (mi) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                                        mi.imageUrl,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 80,
                                            height: 80,
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
                                            mi.name,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            mi.description,
                                            style: GoogleFonts.inter(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '\$${mi.price.toStringAsFixed(2)}',
                                            style: GoogleFonts.poppins(
                                              color: AppColors.electricGreen,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // Add button
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: AppColors.primaryGradient,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.add, color: Colors.white),
                                        onPressed: () {
                                          ref.read(cartNotifierProvider.notifier).addToCart(mi);

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('${mi.name} added to cart'),
                                              duration: const Duration(seconds: 1),
                                              backgroundColor: AppColors.surfaceDark,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ).toList(),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                ],
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.electricGreen),
            ),
            error: (e, st) => Center(
              child: Text('Error: $e', style: const TextStyle(color: Colors.white)),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.electricGreen),
        ),
        error: (e, st) => Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
