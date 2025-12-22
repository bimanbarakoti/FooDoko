// lib/features/ai/services/ai_recommendation_service.dart
import 'dart:math';
import 'package:flutter/foundation.dart';

class AIRecommendationService {
  static final Map<String, List<String>> _userPreferences = {};
  static final Map<String, double> _itemRatings = {};
  static final List<Map<String, dynamic>> _userBehavior = [];

  // AI-powered food recommendation based on user behavior
  static List<Map<String, dynamic>> getPersonalizedRecommendations(String userId) {
    final preferences = _userPreferences[userId] ?? [];
    final behavior = _userBehavior.where((b) => b['userId'] == userId).toList();
    
    // Use preferences and behavior for recommendations
    final confidence = hasItalianPreference ? 0.95 : 0.88;
    final orderBonus = recentOrders > 5 ? 0.05 : 0.0;
    
    // Simulate AI recommendation algorithm
    final recommendations = [
      {
        'id': 'ai_rec_1',
        'name': 'AI Recommended: Truffle Pasta',
        'description': 'Based on your love for Italian cuisine',
        'price': 24.99,
        'confidence': 0.95,
        'reason': 'You ordered pasta 5 times this month',
        'imageUrl': 'https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?w=300&h=200&fit=crop',
        'restaurant': 'AI Chef Kitchen',
        'estimatedTime': '15-20 min',
        'calories': 450,
        'ingredients': ['Truffle', 'Pasta', 'Parmesan', 'Cream'],
        'allergens': ['Gluten', 'Dairy'],
        'nutritionScore': 8.5,
      },
      {
        'id': 'ai_rec_2', 
        'name': 'Smart Choice: Quinoa Buddha Bowl',
        'description': 'Perfect for your fitness goals',
        'price': 18.99,
        'confidence': 0.88,
        'reason': 'Matches your healthy eating pattern',
        'imageUrl': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=300&h=200&fit=crop',
        'restaurant': 'Wellness Kitchen',
        'estimatedTime': '10-15 min',
        'calories': 320,
        'ingredients': ['Quinoa', 'Avocado', 'Chickpeas', 'Kale'],
        'allergens': [],
        'nutritionScore': 9.8,
      },
    ];

    return recommendations;
  }

  // Smart dietary analysis
  static Map<String, dynamic> analyzeDietaryNeeds(String userId) {
    return {
      'calorieGoal': 2000,
      'currentCalories': 1200,
      'remainingCalories': 800,
      'macros': {
        'protein': {'current': 45, 'goal': 150, 'unit': 'g'},
        'carbs': {'current': 120, 'goal': 250, 'unit': 'g'},
        'fat': {'current': 35, 'goal': 65, 'unit': 'g'},
      },
      'recommendations': [
        'Add more protein to reach your fitness goals',
        'You are doing great with vegetables today!',
        'Consider a lighter dinner option',
      ],
      'healthScore': 8.5,
      'streakDays': 12,
    };
  }

  // Track user behavior for AI learning
  static void trackUserBehavior(String userId, String action, Map<String, dynamic> data) {
    _userBehavior.add({
      'userId': userId,
      'action': action,
      'data': data,
      'timestamp': DateTime.now(),
    });

    if (action == 'order' && data.containsKey('cuisine')) {
      final preferences = _userPreferences[userId] ?? [];
      preferences.add(data['cuisine']);
      _userPreferences[userId] = preferences;
    }

    if (kDebugMode) {
      debugPrint('🤖 AI Learning: $action for user $userId');
    }
  }

  // Predict delivery time using AI
  static Map<String, dynamic> predictDeliveryTime(String restaurantId, String userLocation) {
    final random = Random();
    final baseTime = 20 + random.nextInt(20);
    
    return {
      'estimatedTime': baseTime,
      'confidence': 0.85 + random.nextDouble() * 0.15,
      'factors': [
        'Restaurant preparation time: 8-12 min',
        'Distance to location: 2.3 km',
        'Current traffic: Light',
        'Weather conditions: Clear',
      ],
    };
  }

  static void updateItemRating(String itemId, double rating) {
    _itemRatings[itemId] = rating;
  }
}