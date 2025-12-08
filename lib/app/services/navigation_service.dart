// lib/app/services/navigation_service.dart
import 'package:flutter/material.dart';

class NavigationService {
  NavigationService._();
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic>? pushNamed(String name, {Object? args}) {
    return navigatorKey.currentState?.pushNamed(name, arguments: args);
  }

  static void pop() => navigatorKey.currentState?.pop();
}
