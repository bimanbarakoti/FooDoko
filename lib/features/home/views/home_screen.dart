// lib/features/home/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:badges/badges.dart' as badges;

import '../../../app/config/app_colors.dart';
import '../../../app/widgets/glass/frosted_container.dart';
import '../providers/home_providers.dart';
import '../../cart/providers/cart_providers.dart';
import 'category_list_views.dart';
import 'search_delegate.dart';
import '../../../app/providers/theme_provider.dart';
import '../../ai/services/ai_recommendation_service.dart';
import '../../voice/widgets/ultra_voice_assistant.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'AI Recommended', 'Trending', 'Nearby', 'Fast Delivery', 'Top Rated', 'Budget'];
  late AnimationController _animationController;
  late AnimationController _pulseController;
  int _cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _loadAIRecommendations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _loadAIRecommendations() {
    AIRecommendationService.trackUserBehavior('user_1', 'app_open', {'timestamp': DateTime.now().toIso8601String()});
  }

  List<dynamic> _filterRestaurants(List<dynamic> restaurants) {
    switch (_selectedFilter) {
      case 'AI Recommended':
        return restaurants.take(2).toList();
      case 'Top Rated':
        return restaurants.where((r) => r.rating >= 4.7).toList();
      case 'Budget':
        return restaurants.where((r) => r.rating <= 4.5).toList();
      case 'Fast Delivery':
        return restaurants.take(3).toList();
      case 'Nearby':
        return restaurants.where((r) => r.rating >= 4.0).toList();
      case 'Trending':
        return restaurants.reversed.take(4).toList();
      default:
        return restaurants;
    }
  }

  @override
  Widget build(BuildContext context) {
    final popularAsync = ref.watch(popularProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final cartItems = ref.watch(cartProvider);
    _cartItemCount = cartItems.items.length;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Revolutionary App Bar with AI features
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.electricGreen.withOpacity(0.1),
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'FooDoko AI',
                              style: GoogleFonts.poppins(
                                color: AppColors.electricGreen,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ).animate().slideX(duration: 600.ms),
                            Text(
                              '100x Better Than Uber Eats',
                              style: GoogleFonts.inter(
                                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ).animate().slideX(duration: 800.ms, delay: 200.ms),
                          ],
                        ),
                        const Spacer(),
                        // AI Assistant Button
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1.0 + (_pulseController.value * 0.1),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.electricGreen.withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.psychology, color: Colors.white, size: 24),
                              ),
                            );
                          },
                        ).animate().scale(delay: 400.ms),
                        const SizedBox(width: 12),
                        // Theme Toggle
                        IconButton(
                          onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
                          icon: Icon(
                            Theme.of(context).brightness == Brightness.dark 
                                ? Icons.light_mode 
                                : Icons.dark_mode,
                          ),
                        ),
                        // Cart with Badge
                        badges.Badge(
                          badgeContent: Text(
                            _cartItemCount.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          showBadge: _cartItemCount > 0,
                          child: IconButton(
                            onPressed: () => context.push('/cart'),
                            icon: const Icon(Icons.shopping_basket),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // AI Recommendations Section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.electricGreen.withOpacity(0.1),
                    AppColors.accentLight.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.electricGreen.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'AI Recommendations',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        final recommendations = AIRecommendationService.getPersonalizedRecommendations('user_1');
                        if (index >= recommendations.length) return const SizedBox();
                        
                        final rec = recommendations[index];
                        return Container(
                          width: 280,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: Image.network(
                                  rec['imageUrl'],
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 120,
                                      color: Colors.grey.shade300,
                                      child: const Icon(Icons.fastfood, size: 40),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rec['name'],
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).textTheme.titleMedium?.color,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      rec['reason'],
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.electricGreen,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$${rec['price']}',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).textTheme.titleMedium?.color,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.electricGreen.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '${(rec['confidence'] * 100).toInt()}% match',
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              color: AppColors.electricGreen,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ).animate(delay: (index * 200).ms).slideX(begin: 0.3).fadeIn();
                      },
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: 0.2).fadeIn(),
          ),

          // Search Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
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
                        borderRadius: BorderRadius.circular(16),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.white70 
                                  : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'AI-powered search...', 
                              style: GoogleFonts.inter(
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.white70 
                                    : Colors.grey.shade600
                              )
                            ),
                            const Spacer(),
                            Icon(
                              Icons.mic,
                              color: AppColors.electricGreen,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FrostedContainer(
                    blur: 8,
                    borderRadius: BorderRadius.circular(16),
                    padding: const EdgeInsets.all(12),
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (_) => _buildFilterSheet(context),
                        );
                      },
                      child: Icon(
                        Icons.tune,
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.white 
                            : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().slideX(duration: 600.ms, delay: 300.ms),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: categoriesAsync.when(
                data: (cats) => CategoryListView(categories: cats),
                loading: () => const SizedBox(height: 86, child: Center(child: CircularProgressIndicator())),
                error: (e, st) => Center(
                  child: Text('Error loading categories: $e', 
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.white 
                        : Colors.black87
                    )
                  )
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Filter Chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _selectedFilter == filter;
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: isSelected ? AppColors.primaryGradient : null,
                          color: isSelected ? null : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected ? Colors.transparent : AppColors.electricGreen.withOpacity(0.3),
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: AppColors.electricGreen.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 0,
                            ),
                          ] : null,
                        ),
                        child: Text(
                          filter,
                          style: GoogleFonts.inter(
                            color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ).animate(delay: (index * 100).ms).slideX(begin: 0.2).fadeIn();
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Section Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedFilter == 'All' ? 'Popular Near You' : _selectedFilter,
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.white 
                        : Colors.black87, 
                      fontWeight: FontWeight.w600, 
                      fontSize: 20
                    )
                  ),
                  if (_selectedFilter != 'All')
                    Text(
                      'AI Powered',
                      style: GoogleFonts.inter(
                        color: AppColors.electricGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ).animate().slideX(duration: 600.ms),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Restaurant List
          popularAsync.when(
            data: (list) {
              final filteredList = _filterRestaurants(list);
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= filteredList.length) return null;
                    final r = filteredList[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: GestureDetector(
                        onTap: () => context.push('/restaurant/${r.id}'),
                        child: _restaurantCard(context, r),
                      ),
                    );
                  },
                  childCount: filteredList.length,
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator())
            ),
            error: (e, st) => SliverToBoxAdapter(
              child: Center(
                child: Text('Error: $e', 
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.white 
                      : Colors.black87
                  )
                )
              )
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: const UltraVoiceAssistant(),
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
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filters', 
            style: GoogleFonts.poppins(
              color: Theme.of(context).textTheme.titleLarge?.color, 
              fontSize: 18, 
              fontWeight: FontWeight.w700
            )
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _filters.map((filter) => _filterChip(filter)).toList(),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {}); // Refresh the list
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricGreen, 
              minimumSize: const Size.fromHeight(48)
            ),
            child: Text('Apply Filters', 
              style: GoogleFonts.poppins(color: Colors.black)
            ),
          )
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Chip(
        backgroundColor: isSelected ? AppColors.electricGreen : Colors.white12,
        label: Text(
          label, 
          style: GoogleFonts.inter(
            color: isSelected ? Colors.black : Theme.of(context).textTheme.bodyMedium?.color
          )
        ),
      ),
    );
  }
}
