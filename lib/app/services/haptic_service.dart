// lib/app/services/haptic_service.dart
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class HapticService {
  static Future<void> lightImpact() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      HapticFeedback.lightImpact();
    }
  }

  static Future<void> mediumImpact() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      HapticFeedback.mediumImpact();
    }
  }

  static Future<void> heavyImpact() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      HapticFeedback.heavyImpact();
    }
  }

  static Future<void> selectionClick() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      HapticFeedback.selectionClick();
    }
  }

  static Future<void> success() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      await Vibration.vibrate(pattern: [0, 100, 50, 100]);
    }
  }

  static Future<void> error() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      await Vibration.vibrate(pattern: [0, 200, 100, 200, 100, 200]);
    }
  }

  static Future<void> warning() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      await Vibration.vibrate(pattern: [0, 150]);
    }
  }

  static Future<void> notification() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      await Vibration.vibrate(duration: 100);
    }
  }

  static Future<void> paymentSuccess() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      await Vibration.vibrate(pattern: [0, 50, 50, 100, 50, 150]);
    }
  }
}