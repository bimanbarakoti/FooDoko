// lib/app/services/native_service.dart
import 'package:flutter/services.dart';

class NativeService {
  static const MethodChannel _channel = MethodChannel('com.foodoko.app/native');

  static Future<void> optimizePerformance() async {
    try {
      await _channel.invokeMethod('optimizePerformance');
    } catch (e) {
      // Silently handle if native method not available
    }
  }

  static Future<void> enableHapticFeedback() async {
    try {
      await _channel.invokeMethod('enableHapticFeedback');
    } catch (e) {
      // Fallback to Flutter haptic feedback
      HapticFeedback.lightImpact();
    }
  }

  static Future<void> heavyHaptic() async {
    try {
      HapticFeedback.heavyImpact();
    } catch (e) {
      // Silently handle
    }
  }

  static Future<void> selectionHaptic() async {
    try {
      HapticFeedback.selectionClick();
    } catch (e) {
      // Silently handle
    }
  }
}