// lib/features/tracking/views/order_tracking_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../tracking/providers/tracking_providers.dart';
import '../../../app/config/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderTrackingScreen extends ConsumerWidget {
  const OrderTrackingScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(trackingStreamProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Culinary Timeline', style: GoogleFonts.poppins()), backgroundColor: AppColors.deepMidnight),
      backgroundColor: AppColors.deepMidnight,
      body: stream.when(data: (pt){
        return Center(child: Text('Driver at ${pt.lat.toStringAsFixed(4)}, ${pt.lng.toStringAsFixed(4)}', style: GoogleFonts.inter(color: Colors.white)));
      }, loading: ()=> const Center(child: CircularProgressIndicator()), error: (e,st)=> Center(child: Text('Error: $e'))),
    );
  }
}
