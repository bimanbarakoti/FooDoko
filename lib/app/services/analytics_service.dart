// lib/app/services/analytics_service.dart
import 'package:flutter/foundation.dart';

class AnalyticsService {
  static final Map<String, dynamic> _events = {};
  static final List<Map<String, dynamic>> _userJourney = [];

  static void trackEvent(String eventName, {Map<String, dynamic>? parameters}) {
    final event = {
      'name': eventName,
      'timestamp': DateTime.now().toIso8601String(),
      'parameters': parameters ?? {},
    };
    
    _events[eventName] = (_events[eventName] ?? 0) + 1;
    _userJourney.add(event);
    
    if (kDebugMode) {
      print('📊 Analytics: $eventName ${parameters != null ? '- $parameters' : ''}');
    }
  }

  static void trackScreenView(String screenName) {
    trackEvent('screen_view', parameters: {'screen_name': screenName});
  }

  static void trackPurchase(double amount, String currency, List<String> items) {
    trackEvent('purchase', parameters: {
      'value': amount,
      'currency': currency,
      'items': items,
    });
  }

  static void trackAddToCart(String itemId, String itemName, double price) {
    trackEvent('add_to_cart', parameters: {
      'item_id': itemId,
      'item_name': itemName,
      'price': price,
    });
  }

  static void trackSearch(String searchTerm) {
    trackEvent('search', parameters: {'search_term': searchTerm});
  }

  static void trackLogin(String method) {
    trackEvent('login', parameters: {'method': method});
  }

  static void trackShare(String contentType, String itemId) {
    trackEvent('share', parameters: {
      'content_type': contentType,
      'item_id': itemId,
    });
  }

  static Map<String, dynamic> getAnalytics() {
    return {
      'total_events': _events.length,
      'event_counts': _events,
      'user_journey': _userJourney,
      'session_duration': _calculateSessionDuration(),
    };
  }

  static Duration _calculateSessionDuration() {
    if (_userJourney.isEmpty) return Duration.zero;
    
    final first = DateTime.parse(_userJourney.first['timestamp']);
    final last = DateTime.parse(_userJourney.last['timestamp']);
    return last.difference(first);
  }

  static void clearAnalytics() {
    _events.clear();
    _userJourney.clear();
  }
}