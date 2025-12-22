// lib/app/services/speech_service.dart
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

class SpeechService {
  static final SpeechToText _speechToText = SpeechToText();
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _speechEnabled = false;

  static Future<void> initialize() async {
    _speechEnabled = await _speechToText.initialize();
    
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  static bool get isAvailable => _speechEnabled;

  static Future<void> startListening({
    required Function(String) onResult,
    Function(String)? onError,
  }) async {
    if (!_speechEnabled) return;

    await _speechToText.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      localeId: 'en_US',
      onSoundLevelChange: (level) => debugPrint('Sound level: $level'),
    );
  }

  static Future<void> stopListening() async {
    await _speechToText.stop();
  }

  static Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  static Future<void> stop() async {
    await _flutterTts.stop();
  }

  // Voice commands for food ordering
  static Future<void> processVoiceCommand(String command, {
    Function(String)? onRestaurantFound,
    Function(String)? onFoodFound,
    Function()? onCartRequested,
    Function()? onOrderRequested,
  }) async {
    final lowerCommand = command.toLowerCase();

    if (lowerCommand.contains('pizza') || lowerCommand.contains('italian')) {
      onRestaurantFound?.call('Pizza Palace');
      await speak('Opening Pizza Palace menu');
    } else if (lowerCommand.contains('burger') || lowerCommand.contains('american')) {
      onRestaurantFound?.call('Burger Junction');
      await speak('Opening Burger Junction menu');
    } else if (lowerCommand.contains('sushi') || lowerCommand.contains('japanese')) {
      onRestaurantFound?.call('Sakura Sushi');
      await speak('Opening Sakura Sushi menu');
    } else if (lowerCommand.contains('cart') || lowerCommand.contains('basket')) {
      onCartRequested?.call();
      await speak('Opening your cart');
    } else if (lowerCommand.contains('order') || lowerCommand.contains('checkout')) {
      onOrderRequested?.call();
      await speak('Proceeding to checkout');
    } else if (lowerCommand.contains('add') && lowerCommand.contains('cart')) {
      await speak('Item added to cart');
    } else {
      await speak('Sorry, I did not understand that command');
    }
  }

  // Accessibility features
  static Future<void> announceScreen(String screenName) async {
    await speak('Now on $screenName screen');
  }

  static Future<void> announceAction(String action) async {
    await speak(action);
  }
}