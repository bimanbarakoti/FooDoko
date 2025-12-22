import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import 'app/router/app_router.dart';
import 'app/config/app_themes.dart';
import 'app/providers/theme_provider.dart';
import 'app/services/permission_service.dart';
import 'app/services/speech_service.dart';
import 'app/services/analytics_service.dart';
import 'app/services/native_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services based on platform
  if (!kIsWeb) {
    await SpeechService.initialize();
    if (Platform.isAndroid || Platform.isIOS) {
      await NativeService.optimizePerformance();
    }
  }
  
  // Track app launch
  AnalyticsService.trackEvent('app_launch');
  
  runApp(
    const ProviderScope(
      child: FoodokoApp(),
    ),
  );
}

class FoodokoApp extends ConsumerStatefulWidget {
  const FoodokoApp({super.key});

  @override
  ConsumerState<FoodokoApp> createState() => _FoodokoAppState();
}

class _FoodokoAppState extends ConsumerState<FoodokoApp> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Request permissions only on mobile platforms
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        await PermissionService.requestAllPermissions(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'FooDoko - Food Delivery',
      routerConfig: AppRouter.router,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeMode,
      builder: (context, child) {
        // Responsive design wrapper
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).size.width > 600 ? 1.2 : 1.0,
            ),
          ),
          child: Builder(
            builder: (context) {
              // Global error handling
              ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                return Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Something went wrong',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please restart the app',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                );
              };
              return child ?? const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}
