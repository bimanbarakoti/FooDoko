package com.foodoko.app

import android.content.Context
import android.os.Debug
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.management.ManagementFactory

class AssemblyDebuggerPlugin(private val context: Context) : MethodChannel.MethodCallHandler {
    
    companion object {
        private const val CHANNEL = "foodoko/assembly_debugger"
    }
    
    fun registerWith(flutterEngine: FlutterEngine) {
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
    }
    
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initialize" -> {
                initializeDebugger()
                result.success(null)
            }
            "handleCrash" -> {
                val error = call.argument<String>("error") ?: ""
                val stackTrace = call.argument<String>("stackTrace") ?: ""
                handleCrash(error, stackTrace)
                result.success(null)
            }
            "getSystemInfo" -> {
                result.success(getSystemInfo())
            }
            "optimizeMemory" -> {
                optimizeMemory()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }
    
    private fun initializeDebugger() {
        try {
            // Enable strict mode for debugging
            android.os.StrictMode.setThreadPolicy(
                android.os.StrictMode.ThreadPolicy.Builder()
                    .detectAll()
                    .penaltyLog()
                    .build()
            )
        } catch (e: Exception) {
            android.util.Log.e("AssemblyDebugger", "Failed to initialize: ${e.message}")
        }
    }
    
    private fun handleCrash(error: String, stackTrace: String) {
        android.util.Log.e("FooDokoCrash", "Error: $error")
        android.util.Log.e("FooDokoCrash", "StackTrace: $stackTrace")
    }
    
    private fun getSystemInfo(): Map<String, Any> {
        return mapOf(
            "totalMemory" to Runtime.getRuntime().totalMemory(),
            "freeMemory" to Runtime.getRuntime().freeMemory(),
            "maxMemory" to Runtime.getRuntime().maxMemory(),
            "nativeHeapSize" to Debug.getNativeHeapSize(),
            "nativeHeapAllocatedSize" to Debug.getNativeHeapAllocatedSize(),
            "processorCount" to Runtime.getRuntime().availableProcessors()
        )
    }
    
    private fun optimizeMemory() {
        try {
            System.gc()
            Runtime.getRuntime().gc()
        } catch (e: Exception) {
            android.util.Log.e("AssemblyDebugger", "Memory optimization failed: ${e.message}")
        }
    }
}