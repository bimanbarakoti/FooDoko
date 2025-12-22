// Ultra Voice Assistant Widget
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/config/app_colors.dart';
import '../services/ultra_voice_ai.dart';
import '../providers/voice_providers.dart';

class UltraVoiceAssistant extends ConsumerStatefulWidget {
  const UltraVoiceAssistant({super.key});

  @override
  ConsumerState<UltraVoiceAssistant> createState() => _UltraVoiceAssistantState();
}

class _UltraVoiceAssistantState extends ConsumerState<UltraVoiceAssistant> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);
    _waveController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    UltraVoiceAI.initialize();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _startListening() async {
    ref.read(voiceProvider.notifier).startListening();
    setState(() {});
    _waveController.repeat();
  }

  void _stopListening() async {
    ref.read(voiceProvider.notifier).stopListening();
    _waveController.stop();
  }



  @override
  Widget build(BuildContext context) {
    final voiceState = ref.watch(voiceProvider);
    final isListening = voiceState.isListening;
    
    return Positioned(
      bottom: 100,
      right: 20,
      child: GestureDetector(
        onTap: isListening ? _stopListening : _startListening,
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Transform.scale(
              scale: isListening ? 1.0 + (_waveController.value * 0.3) : 1.0 + (_pulseController.value * 0.1),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isListening 
                        ? [Colors.red, Colors.orange]
                        : [AppColors.electricGreen, Colors.blue],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (isListening ? Colors.red : AppColors.electricGreen).withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: isListening ? 10 : 5,
                    ),
                  ],
                ),
                child: Icon(
                  isListening ? Icons.mic : Icons.psychology,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            );
          },
        ),
      ).animate().slideX(begin: 1.0, duration: 600.ms).fadeIn(),
    );
  }
}