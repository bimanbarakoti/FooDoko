// lib/features/live_tracking/views/live_tracking_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import 'dart:math' as math;

import '../../../app/config/app_colors.dart';

class LiveTrackingScreen extends ConsumerStatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  ConsumerState<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends ConsumerState<LiveTrackingScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late Timer _updateTimer;
  
  int _estimatedTime = 25;
  double _progress = 0.3;
  String _currentStatus = 'Preparing your order';
  String _driverName = 'Alex Johnson';
  double _driverRating = 4.8;
  double _temperature = 65.0;
  
  final List<Map<String, dynamic>> _trackingSteps = [
    {'title': 'Order Confirmed', 'time': '7:15 PM', 'completed': true},
    {'title': 'Preparing Food', 'time': '7:18 PM', 'completed': true},
    {'title': 'Ready for Pickup', 'time': '7:25 PM', 'completed': false},
    {'title': 'Out for Delivery', 'time': '7:30 PM', 'completed': false},
    {'title': 'Delivered', 'time': '7:45 PM', 'completed': false},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _progressController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    _startLiveUpdates();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    _updateTimer.cancel();
    super.dispose();
  }

  void _startLiveUpdates() {
    _updateTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _estimatedTime = math.max(0, _estimatedTime - 1);
          _progress = math.min(1.0, _progress + 0.02);
          _temperature = 65.0 + math.sin(timer.tick * 0.1) * 2;
          
          if (_progress > 0.6 && !_trackingSteps[2]['completed']) {
            _trackingSteps[2]['completed'] = true;
            _currentStatus = 'Ready for pickup';
          }
          if (_progress > 0.8 && !_trackingSteps[3]['completed']) {
            _trackingSteps[3]['completed'] = true;
            _currentStatus = 'Out for delivery';
          }
        });
        
        _progressController.forward().then((_) => _progressController.reverse());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Live Tracking',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Call driver
            },
            icon: const Icon(Icons.phone),
          ),
          IconButton(
            onPressed: () {
              // Message driver
            },
            icon: const Icon(Icons.message),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Status Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.electricGreen.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.2 + 0.1 * _pulseController.value),
                            ),
                            child: const Icon(Icons.fastfood, color: Colors.white, size: 30),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentStatus,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Estimated: $_estimatedTime minutes',
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${(_progress * 100).toInt()}%',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: _progress + (_progressController.value * 0.02),
                        backgroundColor: Colors.white.withValues(alpha: 0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 8,
                      );
                    },
                  ),
                ],
              ),
            ).animate().scale(delay: 200.ms),

            const SizedBox(height: 24),

            // Real-time Metrics
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Temperature',
                    '${_temperature.toStringAsFixed(1)}°C',
                    Icons.thermostat,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Freshness',
                    '98%',
                    Icons.eco,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Quality',
                    'Premium',
                    Icons.star,
                    Colors.amber,
                  ),
                ),
              ],
            ).animate().slideY(delay: 400.ms, begin: 0.3).fadeIn(),

            const SizedBox(height: 24),

            // Driver Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.electricGreen,
                    child: Text(
                      _driverName.split(' ').map((e) => e[0]).join(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _driverName,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.titleMedium?.color,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '$_driverRating • 2.3 km away',
                              style: GoogleFonts.inter(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Driving a Blue Honda Civic',
                          style: GoogleFonts.inter(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.phone, color: AppColors.electricGreen),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.message, color: AppColors.electricGreen),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().slideX(delay: 600.ms, begin: 0.3).fadeIn(),

            const SizedBox(height: 24),

            // Tracking Timeline
            Text(
              'Order Timeline',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ).animate().fadeIn(delay: 800.ms),

            const SizedBox(height: 16),

            ...List.generate(_trackingSteps.length, (index) {
              final step = _trackingSteps[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: step['completed'] 
                            ? AppColors.electricGreen 
                            : Colors.grey.withValues(alpha: 0.3),
                      ),
                      child: Icon(
                        step['completed'] ? Icons.check : Icons.circle,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step['title'],
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: step['completed'] 
                                  ? Theme.of(context).textTheme.titleMedium?.color
                                  : Colors.grey,
                            ),
                          ),
                          Text(
                            step['time'],
                            style: GoogleFonts.inter(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (step['completed'])
                      const Icon(Icons.check_circle, color: AppColors.electricGreen),
                  ],
                ),
              ).animate(delay: (1000 + index * 100).ms).slideX(begin: 0.3).fadeIn();
            }),

            const SizedBox(height: 24),

            // AI Insights
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withValues(alpha: 0.1),
                    Colors.purple.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.psychology, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'AI Delivery Insights',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInsightItem('🚀 Route optimized for fastest delivery'),
                  _buildInsightItem('🌱 2.3kg CO2 saved with eco-friendly route'),
                  _buildInsightItem('📊 Delivery accuracy: 98.5%'),
                  _buildInsightItem('⭐ Driver performance: Excellent'),
                ],
              ),
            ).animate().slideY(delay: 1200.ms, begin: 0.2).fadeIn(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }
}