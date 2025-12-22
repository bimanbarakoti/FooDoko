import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:badges/badges.dart' as badges;

import '../../../app/config/app_colors.dart';
import '../../../app/utils/responsive.dart';
import '../../cart/providers/cart_providers.dart';
import '../../ai/providers/ultra_ai_providers.dart';
import '../../voice/widgets/voice_order_widget.dart';
import '../../ar/widgets/ar_food_viewer.dart';
import '../../../app/widgets/bottom_nav_bar.dart';

class UltraHomeScreen extends ConsumerStatefulWidget {
  const UltraHomeScreen({super.key});

  @override
  ConsumerState<UltraHomeScreen> createState() => _UltraHomeScreenState();
}

class _UltraHomeScreenState extends ConsumerState<UltraHomeScreen> with TickerProviderStateMixin {
  late AnimationController _aiController;
  late AnimationController _arController;
  String _currentMood = 'happy';
  String _currentWeather = 'sunny';
  bool _arMode = false;

  @override
  void initState() {
    super.initState();
    _aiController = AnimationController(duration: const Duration(seconds: 3), vsync: this)..repeat();
    _arController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
  }

  @override
  void dispose() {
    _aiController.dispose();
    _arController.dispose();
    super.dispose();
  }

  void _updateMood(String mood) {
    ref.read(ultraAIProvider.notifier).updateMood(mood);
    setState(() => _currentMood = mood);
  }

  void _updateWeather(String weather) {
    ref.read(ultraAIProvider.notifier).updateWeather(weather);
    setState(() => _currentWeather = weather);
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Revolutionary AI Header
          SliverAppBar(
            expandedHeight: 200,
            floating: true,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.electricGreen,
                      AppColors.accentLight,
                      Colors.purple.shade400,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
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
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [Colors.white, Colors.white.withValues(alpha: 0.3)],
                                      ),
                                    ),
                                    child: const Icon(Icons.psychology, color: Colors.black, size: 30),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'FooDoko',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: Responsive.getFontSize(context, 24),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'AI Powered • AR Ready • Voice Enabled',
                                    style: GoogleFonts.inter(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // AR Toggle
                            GestureDetector(
                              onTap: () {
                                setState(() => _arMode = !_arMode);
                                _arController.forward().then((_) => _arController.reverse());
                              },
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
                            const SizedBox(width: 12),
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
                        const SizedBox(height: 20),
                        // AI Mood & Weather Detection
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildMoodChip('😊 Happy', 'happy'),
                              const SizedBox(width: 8),
                              _buildMoodChip('😢 Comfort', 'sad'),
                              const SizedBox(width: 8),
                              _buildMoodChip('😤 Energy', 'stressed'),
                              const SizedBox(width: 8),
                              _buildWeatherChip('☀️ Sunny', 'sunny'),
                              const SizedBox(width: 8),
                              _buildWeatherChip('🌧️ Rainy', 'rainy'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Ultra AI Recommendations
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.electricGreen, Colors.blue],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'AI Picks',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: Responsive.isMobile(context) ? 180 : 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      padding: const EdgeInsets.only(left: 16),
                      itemBuilder: (context, index) {
                        final recommendations = ref.watch(ultraAIProvider).recommendations;
                        if (index >= recommendations.length) return const SizedBox();
                        
                        final rec = recommendations[index % recommendations.length];
                        return GestureDetector(
                          onTap: () => context.push('/restaurant/pizza_palace'),
                          child: Container(
                          width: Responsive.isMobile(context) ? 240 : 300,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.electricGreen.withValues(alpha: 0.1),
                                Colors.purple.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.electricGreen.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                child: Stack(
                                  children: [
                                    Image.network(
                                      rec['imageUrl'],
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          height: 100,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [AppColors.electricGreen, Colors.blue],
                                            ),
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.restaurant, size: 30, color: Colors.white),
                                          ),
                                        );
                                      },
                                    ),
                                    if (_arMode)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Icon(Icons.view_in_ar, color: AppColors.electricGreen, size: 16),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
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
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Spacer(),
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
                                          Flexible(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [AppColors.electricGreen, Colors.blue],
                                                ),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '${(rec['confidence'] * 100).toInt()}%',
                                                style: GoogleFonts.inter(
                                                  fontSize: 9,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
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
                        ).animate(delay: (index * 200).ms).slideX(begin: 0.3).fadeIn();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Weather-Based Recommendations
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🌤️ Weather Picks',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      padding: const EdgeInsets.only(left: 16),
                      itemBuilder: (context, index) {
                        final weatherFoods = ref.watch(weatherRecommendationsProvider);
                        final food = weatherFoods[index % weatherFoods.length];
                        
                        return Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.orange.withValues(alpha: 0.1), Colors.red.withValues(alpha: 0.1)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                food['name'],
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).textTheme.titleMedium?.color,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${food['weatherMatch']}% Match',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.orange,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '\$${food['price']}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).textTheme.titleMedium?.color,
                                ),
                              ),
                            ],
                          ),
                        ).animate(delay: (index * 150).ms).slideY(begin: 0.2).fadeIn();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Ultra Features Grid
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🚀 Quick Actions',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GridView.count(
                    crossAxisCount: Responsive.getCrossAxisCount(context),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: Responsive.isMobile(context) ? 1.1 : 1.3,
                    children: [
                      _buildFeatureCard('🎯 AI Predictor', 'Next order prediction', Colors.blue),
                      _buildFeatureCard('🥗 Nutrition AI', 'Smart calorie optimizer', Colors.green),
                      _buildFeatureCard('🎮 AR Menu', 'See food in 3D', Colors.purple),
                      _buildFeatureCard('🎵 Voice Order', 'Talk to order', Colors.orange),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: _showVoiceOrderDialog,
        backgroundColor: AppColors.electricGreen,
        child: const Icon(Icons.mic, color: Colors.white),
      ).animate().scale(delay: 1000.ms),
    );
  }

  Widget _buildMoodChip(String label, String mood) {
    final isSelected = _currentMood == mood;
    return GestureDetector(
      onTap: () => _updateMood(mood),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? AppColors.electricGreen : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherChip(String label, String weather) {
    final isSelected = _currentWeather == weather;
    return GestureDetector(
      onTap: () => _updateWeather(weather),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.orange : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, String subtitle, Color color) {
    return GestureDetector(
      onTap: () => _handleFeatureTap(title),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.titleMedium?.color,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: color,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.arrow_forward, color: color, size: 18),
            ),
          ],
        ),
      ).animate().scale(delay: 300.ms),
    );
  }

  void _handleFeatureTap(String title) {
    if (title.contains('Voice')) {
      _showVoiceOrderDialog();
    } else if (title.contains('AR')) {
      _showARFoodViewer();
    } else if (title.contains('AI Predictor')) {
      _showAIPrediction();
    } else if (title.contains('Nutrition')) {
      _showNutritionAnalysis();
    }
  }

  void _showVoiceOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: const VoiceOrderWidget(),
      ),
    );
  }

  void _showARFoodViewer() {
    final sampleFood = {
      'name': 'Margherita Pizza',
      'price': 18.99,
      'imageUrl': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
    };
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ARFoodViewer(foodItem: sampleFood),
      ),
    );
  }

  void _showAIPrediction() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.psychology, color: AppColors.electricGreen),
            const SizedBox(width: 8),
            Text(
              'AI Prediction',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Based on your order history and preferences:',
              style: GoogleFonts.inter(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.electricGreen.withValues(alpha: 0.1), Colors.blue.withValues(alpha: 0.1)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next Order Prediction',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: AppColors.electricGreen,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Margherita Pizza',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '94% confidence • Estimated time: 7:30 PM',
                    style: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.inter(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(cartProvider.notifier).addPopularItem('pizza');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Added predicted item to cart!'),
                  backgroundColor: AppColors.electricGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.electricGreen),
            child: Text('Add to Cart', style: GoogleFonts.inter(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showNutritionAnalysis() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.analytics, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              'Nutrition AI',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.withValues(alpha: 0.1), Colors.blue.withValues(alpha: 0.1)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Daily Nutrition Goal',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildNutritionStat('Calories', '1,250/2,000', Colors.orange),
                      _buildNutritionStat('Protein', '45/60g', Colors.red),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildNutritionStat('Carbs', '120/250g', Colors.blue),
                      _buildNutritionStat('Fat', '35/65g', Colors.purple),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '💡 Suggestion: Add more vegetables for better balance',
                      style: GoogleFonts.inter(
                        color: Colors.green,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.inter(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionStat(String label, String value, Color color) {
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
}