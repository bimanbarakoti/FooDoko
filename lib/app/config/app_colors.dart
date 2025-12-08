// lib/app/config/app_colors.dart
import 'package:flutter/material.dart';

/// Centralized color definitions for FooDoko app
class AppColors {
  AppColors._();

  /// Brand
  static const Color electricGreen = Color(0xFF00E676);

  /// Backgrounds
  static const Color deepMidnight = Color(0xFF101010);
  static const Color surfaceDark = Color(0xFF1C1C1C);
  static const Color lightBackground = Color(0xFFF6F7FB);

  /// Text
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textMuted = Color(0xFFBDBDBD);

  /// Accents
  static const Color accentLight = Color(0xFF00FF9D);
  static const Color danger = Color(0xFFFF5252);

  /// Shadows
  static const Color shadow = Colors.black38;

  /// Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [electricGreen, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Colors.white24, Colors.white10],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
