// lib/features/auth/views/splash_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/config/app_constants.dart';
import '../../../app/config/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: AppConstants.splashDelaySeconds), _next);
  }
  void _next() {
    // navigate to login
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepMidnight,
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 96, height: 96, decoration: BoxDecoration(shape: BoxShape.circle, gradient: AppColors.primaryGradient), child: const Icon(Icons.fastfood_rounded, color: Colors.white, size: 44)),
          const SizedBox(height: 12),
          Text(AppConstants.appName, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white)),
        ]),
      ),
    );
  }
}
