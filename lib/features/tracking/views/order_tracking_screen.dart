import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/config/app_colors.dart';
import '../providers/tracking_providers.dart';
import '../services/ultra_live_tracking.dart';

class OrderTrackingScreen extends ConsumerStatefulWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends ConsumerState<OrderTrackingScreen> {
  @override
  void initState() {
    super.initState();
    // Start tracking when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(trackingProvider.notifier).startTracking(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final trackingState = ref.watch(trackingProvider);
    final orderData = trackingState.activeOrders[widget.orderId];

    return Scaffold(
      backgroundColor: AppColors.deepMidnight,
      appBar: AppBar(
        title: Text('Order Tracking', style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: AppColors.deepMidnight,
      ),
      body: orderData == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.electricGreen))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Status Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.electricGreen.withValues(alpha: 0.1), Colors.blue.withValues(alpha: 0.1)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${widget.orderId}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          orderData['message'] ?? 'Processing your order...',
                          style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: (orderData['progress'] ?? 0.0).toDouble(),
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.electricGreen),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ETA: ${orderData['estimatedTime'] ?? 'Calculating...'}',
                          style: GoogleFonts.inter(color: AppColors.electricGreen, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Live Metrics
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard('Temperature', orderData['temperature'] ?? 'N/A', Icons.thermostat),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricCard('Freshness', orderData['freshness'] ?? 'N/A', Icons.eco),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Delivery Insights
                  Consumer(
                    builder: (context, ref, child) {
                      final insights = ref.watch(deliveryInsightsProvider(widget.orderId));
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery Insights',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildInsightRow('Carbon Footprint', insights['carbonFootprint']),
                            _buildInsightRow('Vehicle Type', insights['vehicleType']),
                            _buildInsightRow('Driver Rating', '${insights['driverRating']}/5.0'),
                            _buildInsightRow('Quality Score', '${insights['qualityScore']}/100'),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.electricGreen, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
          ),
          Text(
            value.toString(),
            style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}