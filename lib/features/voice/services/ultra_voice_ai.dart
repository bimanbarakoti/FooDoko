// Ultra Voice AI Assistant
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class UltraVoiceAI {
  static final SpeechToText _speech = SpeechToText();
  static final FlutterTts _tts = FlutterTts();
  static bool _isListening = false;

  static Future<void> initialize() async {
    await _speech.initialize();
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.6);
    await _tts.setPitch(1.1);
  }

  // Ultra Natural Language Processing
  static Future<Map<String, dynamic>> processNaturalCommand(String command) async {
    final lower = command.toLowerCase();
    
    if (lower.contains('order') || lower.contains('want') || lower.contains('get me')) {
      return await _processOrderCommand(lower);
    }
    
    if (lower.contains('feel') || lower.contains('mood')) {
      return await _processMoodCommand(lower);
    }
    
    if (lower.contains('healthy') || lower.contains('diet') || lower.contains('calories')) {
      return await _processDietCommand(lower);
    }
    
    return {
      'type': 'general',
      'response': "I'm your ultra food AI! I can help you order, find restaurants, check nutrition, and more. What would you like to do?",
      'suggestions': ['Order food', 'Find healthy options', 'Surprise me'],
    };
  }

  static Future<Map<String, dynamic>> _processOrderCommand(String command) async {
    final foods = ['pizza', 'burger', 'sushi', 'pasta', 'salad'];
    final detectedFood = foods.firstWhere((food) => command.contains(food), orElse: () => '');
    
    if (detectedFood.isNotEmpty) {
      return {
        'type': 'order',
        'food': detectedFood,
        'response': "Perfect! I found amazing $detectedFood options nearby. Shall I add the top-rated $detectedFood to your cart?",
        'action': 'show_food_options',
        'confidence': 95,
      };
    }
    
    return {
      'type': 'order_clarification',
      'response': "What type of food are you craving? Pizza, burgers, sushi, or something else?",
      'suggestions': ['Pizza', 'Burgers', 'Sushi', 'Surprise me'],
    };
  }

  static Future<Map<String, dynamic>> _processMoodCommand(String command) async {
    final moods = {'happy': 'celebration', 'sad': 'comfort', 'stressed': 'calming'};
    
    String detectedMood = 'happy';
    for (final mood in moods.keys) {
      if (command.contains(mood)) {
        detectedMood = mood;
        break;
      }
    }
    
    return {
      'type': 'mood_recommendation',
      'mood': detectedMood,
      'response': "I sense you're feeling $detectedMood! I recommend ${moods[detectedMood]} foods perfect for your mood.",
      'recommendations': ['Comfort chocolate', 'Energizing smoothie', 'Mood-boosting salad'],
    };
  }

  static Future<Map<String, dynamic>> _processDietCommand(String command) async {
    if (command.contains('lose weight') || command.contains('diet')) {
      return {
        'type': 'diet_plan',
        'response': "I found 12 delicious meals under 400 calories. The Mediterranean bowl has perfect macros!",
        'calories': 350,
        'recommendations': ['Mediterranean bowl', 'Protein smoothie', 'Veggie wrap'],
      };
    }
    
    return {
      'type': 'healthy_options',
      'response': "Health-conscious choice! I've curated nutritious options with perfect balance.",
      'recommendations': ['Superfood salad', 'Lean protein bowl', 'Antioxidant smoothie'],
    };
  }

  static Future<void> startAdvancedListening({
    required Function(Map<String, dynamic>) onResult,
  }) async {
    if (!await _speech.initialize()) return;
    
    _isListening = true;
    await _speech.listen(
      onResult: (result) async {
        final command = result.recognizedWords;
        final response = await processNaturalCommand(command);
        onResult(response);
      },
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 2),
      localeId: 'en_US',
    );
  }

  static bool get isListening => _isListening;

  static Future<void> speakWithPersonality(String text) async {
    final personalizedText = "Hey there! $text Let me know if you need anything else!";
    await _tts.speak(personalizedText);
  }

  static Future<void> stopListening() async {
    _isListening = false;
    await _speech.stop();
  }
}