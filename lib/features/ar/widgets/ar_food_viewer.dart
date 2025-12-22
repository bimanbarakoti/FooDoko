// lib/features/ar/widgets/ar_food_viewer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

import '../../../app/config/app_colors.dart';

class ARFoodViewer extends ConsumerStatefulWidget {
  final Map<String, dynamic> foodItem;
  
  const ARFoodViewer({super.key, required this.foodItem});

  @override
  ConsumerState<ARFoodViewer> createState() => _ARFoodViewerState();
}

class _ARFoodViewerState extends ConsumerState<ARFoodViewer> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _floatController;
  late AnimationController _particleController;
  
  bool _showNutrition = false;
  bool _show3D = true;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
    
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _floatController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.8),
            Colors.black.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.electricGreen.withValues(alpha: 0.5), width: 2),
      ),
      child: Stack(
        children: [
          // AR Background Effect
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ARBackgroundPainter(_particleController.value),
                );
              },
            ),
          ),

          // AR Header
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.electricGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.view_in_ar, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'AR MODE',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => setState(() => _showNutrition = !_showNutrition),
                  icon: Icon(
                    Icons.analytics,
                    color: _showNutrition ? AppColors.electricGreen : Colors.white70,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _show3D = !_show3D),
                  icon: Icon(
                    Icons.threed_rotation,
                    color: _show3D ? AppColors.electricGreen : Colors.white70,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ).animate().slideY(begin: -0.5).fadeIn(),

          // 3D Food Model
          if (_show3D)
            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([_rotationController, _floatController]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 10 * _floatController.value),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_rotationController.value * 2 * math.pi)
                        ..rotateX(0.2),
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.electricGreen.withValues(alpha: 0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Food Image with 3D effect
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.electricGreen.withValues(alpha: 0.5),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  widget.foodItem['imageUrl'] ?? '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: AppColors.primaryGradient,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.fastfood,
                                        size: 60,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            
                            // Holographic rings
                            ...List.generate(3, (index) {
                              return AnimatedBuilder(
                                animation: _rotationController,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: (_rotationController.value + index * 0.3) * 2 * math.pi,
                                    child: Container(
                                      width: 180 + index * 20,
                                      height: 180 + index * 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.electricGreen.withValues(alpha: 0.3 - index * 0.1),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ).animate().scale(delay: 300.ms),

          // Nutrition Visualization
          if (_showNutrition)
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.electricGreen.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.analytics, color: AppColors.electricGreen, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Nutrition Analysis',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildNutritionParticle('Calories', '320', Colors.orange),
                        _buildNutritionParticle('Protein', '15g', Colors.red),
                        _buildNutritionParticle('Carbs', '45g', Colors.blue),
                        _buildNutritionParticle('Fat', '12g', Colors.purple),
                      ],
                    ),
                  ],
                ),
              ),
            ).animate().slideY(begin: 0.5).fadeIn(),

          // Action Buttons
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                    label: Text(
                      'Add to Cart',
                      style: GoogleFonts.inter(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.electricGreen,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ).animate().slideY(begin: 0.5).fadeIn(delay: 600.ms),

          // Food Info Overlay
          Positioned(
            top: 80,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.foodItem['name'] ?? 'Food Item',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '\$${widget.foodItem['price']?.toStringAsFixed(2) ?? '0.00'}',
                    style: GoogleFonts.poppins(
                      color: AppColors.electricGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().slideX(begin: -0.5).fadeIn(delay: 400.ms),
        ],
      ),
    );
  }

  Widget _buildNutritionParticle(String label, String value, Color color) {
    return Expanded(
      child: AnimatedBuilder(
        animation: _particleController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 5 * math.sin(_particleController.value * 2 * math.pi)),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.3),
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      value,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ARBackgroundPainter extends CustomPainter {
  final double animationValue;
  
  ARBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.electricGreen.withValues(alpha: 0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw grid lines
    for (int i = 0; i < 10; i++) {
      final y = (size.height / 10) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    for (int i = 0; i < 10; i++) {
      final x = (size.width / 10) * i;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw scanning line
    final scanPaint = Paint()
      ..color = AppColors.electricGreen.withValues(alpha: 0.5)
      ..strokeWidth = 2;

    final scanY = size.height * animationValue;
    canvas.drawLine(
      Offset(0, scanY),
      Offset(size.width, scanY),
      scanPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}