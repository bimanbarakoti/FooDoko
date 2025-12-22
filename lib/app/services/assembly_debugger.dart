// lib/app/services/assembly_debugger.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class AssemblyDebugger {
  static const MethodChannel _channel = MethodChannel('foodoko/assembly_debugger');
  
  static Future<void> initialize() async {
    if (kDebugMode) {
      try {
        if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
          await _channel.invokeMethod('initialize');
        }
      } catch (e) {
        debugPrint('Assembly debugger not available: $e');
      }
    }
  }

  static Future<void> handleCrash(String error, StackTrace stackTrace) async {
    try {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        await _channel.invokeMethod('handleCrash', {
          'error': error,
          'stackTrace': stackTrace.toString(),
        });
      }
    } catch (e) {
      debugPrint('Crash handler failed: $e');
    }
  }

  static Future<Map<String, dynamic>> getSystemInfo() async {
    try {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        final result = await _channel.invokeMethod('getSystemInfo');
        return Map<String, dynamic>.from(result);
      }
    } catch (e) {
      debugPrint('System info unavailable: $e');
    }
    return {};
  }

  static Future<void> optimizeMemory() async {
    try {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        await _channel.invokeMethod('optimizeMemory');
      }
    } catch (e) {
      debugPrint('Memory optimization failed: $e');
    }
  }
}