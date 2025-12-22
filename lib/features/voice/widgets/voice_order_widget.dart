// lib/features/voice/widgets/voice_order_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../app/config/app_colors.dart';
import '../../../app/services/speech_service.dart';
import '../../cart/providers/cart_providers.dart';

class VoiceOrderWidget extends ConsumerStatefulWidget {
  const VoiceOrderWidget({super.key});

  @override
  ConsumerState<VoiceOrderWidget> createState() => _VoiceOrderWidgetState();
}

class _VoiceOrderWidgetState extends ConsumerState<VoiceOrderWidget> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  
  bool _isListening = false;
  String _recognizedText = '';
  String _aiResponse = '';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  Future<void> _startListening() async {
    if (!SpeechService.isAvailable) {
      await SpeechService.speak('Voice recognition is not available');
      return;
    }

    setState(() {
      _isListening = true;
      _recognizedText = '';
      _aiResponse = '';
    });

    _pulseController.repeat();
    _waveController.repeat();

    await SpeechService.speak('I\'m listening. What would you like to order?');

    await SpeechService.startListening(
      onResult: (text) {
        setState(() => _recognizedText = text);
      },
    );

    await Future.delayed(const Duration(seconds: 5));
    await _stopListening();
  }

  Future<void> _stopListening() async {
    await SpeechService.stopListening();
    
    setState(() => _isListening = false);
    _pulseController.stop();
    _waveController.stop();

    if (_recognizedText.isNotEmpty) {
      await _processVoiceCommand(_recognizedText);
    } else {
      setState(() => _aiResponse = 'I didn\'t catch that. Please try again.');
      await SpeechService.speak('I didn\'t catch that. Please try again.');
    }
  }

  Future<void> _processVoiceCommand(String command) async {
    final lowerCommand = command.toLowerCase();
    
    setState(() => _aiResponse = 'Processing your order...');
    
    if (lowerCommand.contains('pizza')) {
      await _addItemToCart('pizza', 'Margherita Pizza', 18.99);
      setState(() => _aiResponse = 'Added Margherita Pizza to your cart!');
      await SpeechService.speak('Great choice! I\'ve added a Margherita Pizza to your cart for \$18.99');
    } else if (lowerCommand.contains('burger')) {
      await _addItemToCart('burger', 'Classic Burger', 14.99);
      setState(() => _aiResponse = 'Added Classic Burger to your cart!');
      await SpeechService.speak('Perfect! I\'ve added a Classic Burger to your cart for \$14.99');
    } else if (lowerCommand.contains('sushi')) {
      await _addItemToCart('sushi', 'Salmon Roll', 22.99);
      setState(() => _aiResponse = 'Added Salmon Roll to your cart!');
      await SpeechService.speak('Excellent! I\'ve added a Salmon Roll to your cart for \$22.99');
    } else if (lowerCommand.contains('salad')) {
      await _addItemToCart('salad', 'Caesar Salad', 12.99);
      setState(() => _aiResponse = 'Added Caesar Salad to your cart!');
      await SpeechService.speak('Healthy choice! I\'ve added a Caesar Salad to your cart for \$12.99');
    } else if (lowerCommand.contains('cart') || lowerCommand.contains('checkout')) {
      setState(() => _aiResponse = 'Opening your cart...');
      await SpeechService.speak('Opening your cart now');
      // Navigate to cart would go here
    } else if (lowerCommand.contains('recommend') || lowerCommand.contains('suggest')) {
      setState(() => _aiResponse = 'Based on your preferences, I recommend our Margherita Pizza!');
      await SpeechService.speak('Based on your preferences and the current weather, I recommend our delicious Margherita Pizza. It\'s our most popular item!');
    } else {
      setState(() => _aiResponse = 'I can help you order pizza, burgers, sushi, or salads. What would you like?');
      await SpeechService.speak('I can help you order pizza, burgers, sushi, or salads. What would you like to try?');
    }
  }

  Future<void> _addItemToCart(String type, String name, double price) async {
    final cartItem = CartItem(
      id: '${type}_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      price: price,
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
      restaurantId: 'voice_order',
      restaurantName: 'FooDoko Voice Order',
    );
    
    ref.read(cartProvider.notifier).addItem(cartItem);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.electricGreen.withValues(alpha: 0.1),
            Colors.blue.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.electricGreen.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // Header with back button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Voice Order',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.withValues(alpha: 0.2),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),

          // Voice Button
          GestureDetector(
            onTap: _isListening ? _stopListening : _startListening,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: _isListening 
                        ? RadialGradient(
                            colors: [
                              AppColors.electricGreen,
                              AppColors.electricGreen.withValues(alpha: 0.3),
                            ],
                          )
                        : AppColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.electricGreen.withValues(alpha: _isListening ? 0.5 + 0.3 * _pulseController.value : 0.3),
                        blurRadius: _isListening ? 30 + 20 * _pulseController.value : 20,
                        spreadRadius: _isListening ? 5 + 5 * _pulseController.value : 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    size: 50,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ).animate().scale(delay: 200.ms),

          const SizedBox(height: 20),

          // Status Text
          Text(
            _isListening ? 'Listening...' : 'Tap to start voice ordering',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms),

          if (_isListening) ...[
            const SizedBox(height: 16),
            // Voice Wave Animation
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final delay = index * 0.2;
                    final animValue = (_waveController.value + delay) % 1.0;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 4,
                      height: 20 + 30 * animValue,
                      decoration: BoxDecoration(
                        color: AppColors.electricGreen,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                );
              },
            ).animate().fadeIn(),
          ],

          if (_recognizedText.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You said:',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _recognizedText,
                    style: GoogleFonts.inter(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: 0.3).fadeIn(),
          ],

          if (_aiResponse.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.electricGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.psychology, color: AppColors.electricGreen, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'FooDoko AI:',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.electricGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _aiResponse,
                    style: GoogleFonts.inter(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: 0.3).fadeIn(),
          ],

          // Action Buttons
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigate to cart
                  },
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  label: Text(
                    'View Cart',
                    style: GoogleFonts.inter(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.electricGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _recognizedText = '';
                      _aiResponse = '';
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(
                    'Try Again',
                    style: GoogleFonts.inter(),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.electricGreen),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Quick Commands
          const SizedBox(height: 16),
          Text(
            'Try saying: "I want pizza", "Add burger to cart", "What do you recommend?"',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 600.ms),
        ],
      ),
    );
  }
}