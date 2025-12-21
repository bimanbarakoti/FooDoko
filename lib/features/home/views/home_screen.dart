// lib/features/home/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../app/config/app_colors.dart';
import '../../../app/widgets/glass/frosted_container.dart';
import '../../home/providers/home_providers.dart';
import 'package:foodoko/features/home/views/category_list_views.dart';
import 'search_delegate.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularAsync = ref.watch(popularProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.deepMidnight,
        elevation: 0,
        title: Row(
          children: [
            Text('FooDoko', style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Expanded(child: Container()), // push actions right
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/cart'),
            icon: const Icon(Icons.shopping_basket),
          ),
        ],
      ),
      backgroundColor: AppColors.deepMidnight,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            // Search + filter row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Search field (tappable)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // collect searchable list: restaurants names from popular provider
                        final restaurants = popularAsync.maybeWhen(
                          data: (list) => list,
                          orElse: () => <dynamic>[],
                        );
                        showSearch(
                          context: context,
                          delegate: AppSearchDelegate(restaurants),
                        );
                      },
                      child: FrostedContainer(
                        blur: 8,
                        borderRadius: BorderRadius.circular(12),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.white70),
                            const SizedBox(width: 12),
                            Text('Search dishes, restaurants...', style: GoogleFonts.inter(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Filter button (glass)
                  FrostedContainer(
                    blur: 8,
                    borderRadius: BorderRadius.circular(12),
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        // TODO: open filter modal
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (_) => _buildFilterSheet(context),
                        );
                      },
                      child: const Icon(Icons.tune, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Categories (glass-style)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: categoriesAsync.when(
                data: (cats) => CategoryListView(categories: cats),
                loading: () => const SizedBox(height: 86, child: Center(child: CircularProgressIndicator())),
                error: (e, st) => Center(child: Text('Error loading categories: $e', style: const TextStyle(color: Colors.white))),
              ),
            ),

            const SizedBox(height: 18),

            // Promo banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _promoBanner(),
            ),

            const SizedBox(height: 18),

            // Popular near you (list)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Popular Near You', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
            ),

            const SizedBox(height: 12),

            // Restaurant list
            popularAsync.when(
              data: (list) {
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final r = list[i];
                    return GestureDetector(
                      onTap: () => context.push('/restaurant/${r.id}'),
                      child: _restaurantCard(context, r),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _promoBanner() {
    return Container(
      height: 120,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: AppColors.primaryGradient,
      ),
      child: Stack(
        children: [
          // subtle overlay
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.08))),
          Positioned(
            left: 18,
            top: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🔥 20% OFF on Pizza Tonight', style: GoogleFonts.poppins(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text('Use code PIZZA20 • Valid today', style: GoogleFonts.inter(color: Colors.black87)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: Text('Grab Offer', style: GoogleFonts.poppins(color: AppColors.electricGreen)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _restaurantCard(BuildContext context, dynamic r) {
    // r should be your RestaurantModel
    return Container(
      height: 180,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Positioned.fill(child: Image.network(r.imageUrl, fit: BoxFit.cover)),
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: FrostedContainer(
              blur: 8,
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r.name, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(r.shortDesc, style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSheet(BuildContext context) {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filters', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _filterChip('Open Now'),
              _filterChip('Fast Delivery'),
              _filterChip('Top Rated'),
              _filterChip('Budget'),
              _filterChip('Veg Friendly'),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.electricGreen, minimumSize: const Size.fromHeight(48)),
            child: Text('Apply Filters', style: GoogleFonts.poppins(color: Colors.black)),
          )
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    return Chip(
      backgroundColor: Colors.white12,
      label: Text(label, style: GoogleFonts.inter(color: Colors.white)),
    );
  }
}
