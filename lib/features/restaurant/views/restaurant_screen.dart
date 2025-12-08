// lib/features/restaurant/views/restaurant_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/widgets/glass/frosted_container.dart';
import '../../restaurant/providers/restaurant_providers.dart';
import '../../../app/config/app_colors.dart';


import '../../cart/providers/cart_providers.dart';

class RestaurantScreen extends ConsumerWidget {
  final String restaurantId;
  const RestaurantScreen({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = ref.watch(menuSectionsProvider(restaurantId));
    final items = ref.watch(menuItemsProvider(restaurantId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Chef\'s Scroll', style: GoogleFonts.poppins()),
        backgroundColor: AppColors.deepMidnight,
      ),
      backgroundColor: AppColors.deepMidnight,
      body: sections.when(
        data: (secs) {
          return items.when(
            data: (its) {
              return ListView(
                children: [
                  Container(
                    height: 140,
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white12,
                    ),
                    child: Center(
                      child: Text(
                        restaurantId,
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 22),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  ...secs.map((s) {
                    final sectionItems = its.where((i) => s.itemIds.contains(i.id)).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Text(
                            s.title,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        // items list
                        ...sectionItems.map(
                              (mi) => Column(
                            children: [
                              ListTile(
                                title: Text(
                                  mi.name,
                                  style: GoogleFonts.inter(color: Colors.white),
                                ),
                                subtitle: Text(
                                  '\$${mi.price.toStringAsFixed(2)}',
                                  style: GoogleFonts.inter(color: Colors.white70),
                                ),
                                tileColor: Colors.white12,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),


                                trailing: IconButton(
                                  icon: const Icon(Icons.add),
                                  color: AppColors.electricGreen,
                                  onPressed: () {
                                    ref.read(cartProvider.notifier).addToCart(mi);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${mi.name} added to cart'),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 6),
                            ],
                          ),
                        ).toList(),
                      ],
                    );
                  }).toList(),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
