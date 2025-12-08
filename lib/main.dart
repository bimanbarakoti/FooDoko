import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/router/app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: FoodokoApp(),
    ),
  );
}

class FoodokoApp extends StatelessWidget {
  const FoodokoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router, // ✅ reference your AppRouter
      theme: ThemeData.dark(), // or your custom theme
    );
  }
}
