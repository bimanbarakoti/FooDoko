package com.foodoko.app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Bundle
import android.view.WindowManager

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.foodoko.app/native"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "optimizePerformance" -> {
                    optimizePerformance()
                    result.success("Performance optimized")
                }
                "enableHapticFeedback" -> {
                    enableHapticFeedback()
                    result.success("Haptic feedback enabled")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Keep screen on during food ordering
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        
        // Optimize for food delivery app
        optimizePerformance()
    }

    private fun optimizePerformance() {
        // Enable hardware acceleration
        window.setFlags(
            WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED,
            WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED
        )
    }

    private fun enableHapticFeedback() {
        // Haptic feedback for better UX
        window.decorView.performHapticFeedback(
            android.view.HapticFeedbackConstants.VIRTUAL_KEY
        )
    }
}