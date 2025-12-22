import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ultra_voice_ai.dart';

// Voice AI State
class VoiceState {
  final bool isListening;
  final String lastCommand;
  final Map<String, dynamic> lastResponse;
  final List<String> suggestions;
  final bool isProcessing;

  VoiceState({
    this.isListening = false,
    this.lastCommand = '',
    this.lastResponse = const {},
    this.suggestions = const [],
    this.isProcessing = false,
  });

  VoiceState copyWith({
    bool? isListening,
    String? lastCommand,
    Map<String, dynamic>? lastResponse,
    List<String>? suggestions,
    bool? isProcessing,
  }) {
    return VoiceState(
      isListening: isListening ?? this.isListening,
      lastCommand: lastCommand ?? this.lastCommand,
      lastResponse: lastResponse ?? this.lastResponse,
      suggestions: suggestions ?? this.suggestions,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

class VoiceNotifier extends StateNotifier<VoiceState> {
  VoiceNotifier() : super(VoiceState());

  void startListening() async {
    state = state.copyWith(isListening: true, isProcessing: true);
    
    await UltraVoiceAI.startAdvancedListening(
      onResult: (response) {
        state = state.copyWith(
          isListening: false,
          isProcessing: false,
          lastResponse: response,
          suggestions: List<String>.from(response['suggestions'] ?? []),
        );
        
        // Speak the response
        final responseText = response['response'] ?? '';
        if (responseText.isNotEmpty) {
          UltraVoiceAI.speakWithPersonality(responseText);
        }
      },
    );
  }

  void stopListening() async {
    await UltraVoiceAI.stopListening();
    state = state.copyWith(isListening: false, isProcessing: false);
  }

  void processCommand(String command) async {
    state = state.copyWith(lastCommand: command, isProcessing: true);
    
    final response = await UltraVoiceAI.processNaturalCommand(command);
    state = state.copyWith(
      lastResponse: response,
      suggestions: List<String>.from(response['suggestions'] ?? []),
      isProcessing: false,
    );
  }

  void speak(String text) async {
    await UltraVoiceAI.speakWithPersonality(text);
  }
}

// Providers
final voiceProvider = StateNotifierProvider<VoiceNotifier, VoiceState>((ref) {
  return VoiceNotifier();
});

final voiceCommandProvider = Provider.family<Future<Map<String, dynamic>>, String>((ref, command) {
  return UltraVoiceAI.processNaturalCommand(command);
});

final voiceListeningProvider = Provider<bool>((ref) {
  return ref.watch(voiceProvider).isListening;
});

final voiceSuggestionsProvider = Provider<List<String>>((ref) {
  return ref.watch(voiceProvider).suggestions;
});

final lastVoiceResponseProvider = Provider<Map<String, dynamic>>((ref) {
  return ref.watch(voiceProvider).lastResponse;
});