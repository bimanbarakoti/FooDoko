// lib/features/ai/providers/ultra_ai_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ultra_ai_service.dart';

// AI State Model
class UltraAIState {
  final String currentMood;
  final String currentWeather;
  final List<Map<String, dynamic>> recommendations;
  final Map<String, dynamic>? nextOrderPrediction;
  final Map<String, dynamic>? nutritionData;
  final bool isVoiceListening;
  final bool isARMode;

  const UltraAIState({
    this.currentMood = 'happy',
    this.currentWeather = 'sunny',
    this.recommendations = const [],
    this.nextOrderPrediction,
    this.nutritionData,
    this.isVoiceListening = false,
    this.isARMode = false,
  });

  UltraAIState copyWith({
    String? currentMood,
    String? currentWeather,
    List<Map<String, dynamic>>? recommendations,
    Map<String, dynamic>? nextOrderPrediction,
    Map<String, dynamic>? nutritionData,
    bool? isVoiceListening,
    bool? isARMode,
  }) {
    return UltraAIState(
      currentMood: currentMood ?? this.currentMood,
      currentWeather: currentWeather ?? this.currentWeather,
      recommendations: recommendations ?? this.recommendations,
      nextOrderPrediction: nextOrderPrediction ?? this.nextOrderPrediction,
      nutritionData: nutritionData ?? this.nutritionData,
      isVoiceListening: isVoiceListening ?? this.isVoiceListening,
      isARMode: isARMode ?? this.isARMode,
    );
  }
}

// AI State Notifier
class UltraAINotifier extends StateNotifier<UltraAIState> {
  UltraAINotifier() : super(const UltraAIState()) {
    _initializeAI();
  }

  void _initializeAI() {
    // Load initial recommendations
    updateMood('happy');
    updateWeather('sunny');
    _loadNextOrderPrediction();
  }

  void updateMood(String mood) {
    final recommendations = UltraAIService.getMoodBasedRecommendations(mood);
    state = state.copyWith(
      currentMood: mood,
      recommendations: recommendations,
    );
  }

  void updateWeather(String weather) {
    state = state.copyWith(currentWeather: weather);
  }

  void _loadNextOrderPrediction() {
    final prediction = UltraAIService.predictNextOrder();
    state = state.copyWith(nextOrderPrediction: prediction);
  }

  void updateNutritionData(List<String> items) {
    final nutrition = UltraAIService.getNutritionOptimization(items);
    state = state.copyWith(nutritionData: nutrition);
  }

  void toggleVoiceListening() {
    state = state.copyWith(isVoiceListening: !state.isVoiceListening);
  }

  void toggleARMode() {
    state = state.copyWith(isARMode: !state.isARMode);
  }

  Future<Map<String, dynamic>> processVoiceCommand(String command) async {
    return UltraAIService.processVoiceCommand(command);
  }

  Map<String, dynamic> getARFoodData(String foodId) {
    return UltraAIService.getARFoodData(foodId);
  }
}

// Main AI Provider
final ultraAIProvider = StateNotifierProvider<UltraAINotifier, UltraAIState>((ref) {
  return UltraAINotifier();
});

// Weather-based recommendations provider
final weatherRecommendationsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final aiState = ref.watch(ultraAIProvider);
  return UltraAIService.getWeatherBasedRecommendations(aiState.currentWeather);
});

// Next order prediction provider
final nextOrderPredictionProvider = Provider<Map<String, dynamic>?>((ref) {
  final aiState = ref.watch(ultraAIProvider);
  return aiState.nextOrderPrediction;
});

// Nutrition optimization provider
final nutritionOptimizationProvider = Provider<Map<String, dynamic>?>((ref) {
  final aiState = ref.watch(ultraAIProvider);
  return aiState.nutritionData;
});

// Voice command provider
final voiceCommandProvider = Provider<bool>((ref) {
  final aiState = ref.watch(ultraAIProvider);
  return aiState.isVoiceListening;
});

// AR mode provider
final arModeProvider = Provider<bool>((ref) {
  final aiState = ref.watch(ultraAIProvider);
  return aiState.isARMode;
});

// Mood-based color provider
final moodColorProvider = Provider<Map<String, dynamic>>((ref) {
  final aiState = ref.watch(ultraAIProvider);
  
  final moodColors = {
    'happy': {'primary': 0xFF4CAF50, 'secondary': 0xFF8BC34A, 'accent': 0xFFCDDC39},
    'sad': {'primary': 0xFF2196F3, 'secondary': 0xFF03A9F4, 'accent': 0xFF00BCD4},
    'stressed': {'primary': 0xFF9C27B0, 'secondary': 0xFFE91E63, 'accent': 0xFFFF5722},
  };
  
  return moodColors[aiState.currentMood] ?? moodColors['happy']!;
});

// Weather-based theme provider
final weatherThemeProvider = Provider<Map<String, dynamic>>((ref) {
  final aiState = ref.watch(ultraAIProvider);
  
  final weatherThemes = {
    'sunny': {'background': 0xFFFFF9C4, 'accent': 0xFFFF9800},
    'rainy': {'background': 0xFFE3F2FD, 'accent': 0xFF2196F3},
    'cold': {'background': 0xFFF3E5F5, 'accent': 0xFF9C27B0},
  };
  
  return weatherThemes[aiState.currentWeather] ?? weatherThemes['sunny']!;
});