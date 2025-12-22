package com.foodoko.app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Bundle
import android.view.WindowManager

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.foodoko.app/native"
    private lateinit var assemblyDebugger: AssemblyDebuggerPlugin

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Initialize assembly debugger
        assemblyDebugger = AssemblyDebuggerPlugin(this)
        assemblyDebugger.registerWith(flutterEngine)
        
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
        
        try {
            // Keep screen on during food ordering
            window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
            
            // Optimize for food delivery app
            optimizePerformance()
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Initialization failed: ${e.message}")
        }
    }

    private fun optimizePerformance() {
        try {
            // Enable hardware acceleration
            window.setFlags(
                WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED,
                WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED
            )
            
            // Force garbage collection
            System.gc()
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Performance optimization failed: ${e.message}")
        }
    }

    private fun enableHapticFeedback() {
        try {
            // Haptic feedback for better UX
            window.decorView.performHapticFeedback(
                android.view.HapticFeedbackConstants.VIRTUAL_KEY
            )
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Haptic feedback failed: ${e.message}")
        }
    }
}