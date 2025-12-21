// lib/features/auth/views/splash_screen.dart

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/config/app_constants.dart';
import '../../../app/config/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textFadeController;
  late AnimationController _taglineController;
  late AnimationController _shimmerController;
  late AnimationController _bgController;
  late AnimationController _pulseController;

  late Animation<double> _logoScale;
  late Animation<double> _textFade;
  late Animation<double> _taglineFadeUp;
  late Animation<double> _pulse;

  // Tilt effect
  Offset tilt = Offset.zero;

  // Floating particles
  final List<_Particle> particles = [];

  @override
  void initState() {
    super.initState();

    // Init particles
    for (int i = 0; i < 18; i++) {
      particles.add(_Particle.random());
    }

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale =
        CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack);

    _textFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _textFade =
        CurvedAnimation(parent: _textFadeController, curve: Curves.easeIn);

    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );
    _taglineFadeUp =
        CurvedAnimation(parent: _taglineController, curve: Curves.easeOut);

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut);

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 400),
            () => _textFadeController.forward());
    Future.delayed(const Duration(milliseconds: 1000),
            () => _taglineController.forward());

    Timer(const Duration(seconds: AppConstants.splashDelaySeconds), () {
      if (mounted) context.go('/login');
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textFadeController.dispose();
    _taglineController.dispose();
    _shimmerController.dispose();
    _bgController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // Handle tilt movement
  void _onTilt(PointerEvent event) {
    setState(() {
      tilt = (event.localPosition / 200) - const Offset(1.2, 1.2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepMidnight,
      body: Listener(
        onPointerHover: _onTilt,
        child: AnimatedBuilder(
          animation: _bgController,
          builder: (context, child) {
            return Stack(
              children: [
                _animatedBackground(),
                _particleLayer(),
                Center(
                  child: Transform.translate(
                    offset: tilt * 12,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _glassArc(),
                        const SizedBox(height: 14),
                        _logoPulse(),
                        const SizedBox(height: 18),
                        _animatedAppName(),
                        const SizedBox(height: 12),
                        _animatedTagline(),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // 🔵 Glowing Background Waves
  // ------------------------------------------------------------------
  Widget _animatedBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.deepMidnight,
            AppColors.deepMidnight.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // ✨ Floating Particles
  // ------------------------------------------------------------------
  Widget _particleLayer() {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, _) {
        return Stack(
          children: particles.map((p) {
            p.update();
            return Positioned(
              left: p.x,
              top: p.y,
              child: Container(
                width: p.size,
                height: p.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(p.opacity),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // ------------------------------------------------------------------
  // 🟢 Logo Pulse + Glow
  // ------------------------------------------------------------------
  Widget _logoPulse() {
    return ScaleTransition(
      scale: _logoScale,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (_, __) {
          return Container(
            width: 110 + 12 * _pulse.value,
            height: 110 + 12 * _pulse.value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withOpacity(0.4 + 0.2 * _pulse.value),
                  blurRadius: 40 + 10 * _pulse.value,
                  spreadRadius: 5 + 2 * _pulse.value,
                )
              ],
            ),
            child: const Icon(Icons.fastfood_rounded,
                size: 50, color: Colors.white),
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------------
  // 🌫 Glass Arc Behind Logo
  // ------------------------------------------------------------------
  Widget _glassArc() {
    return Container(
      width: 220,
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(120),
        color: Colors.white.withOpacity(0.07),
        backgroundBlendMode: BlendMode.overlay,
      ),
    );
  }

  // ------------------------------------------------------------------
  // ✨ Shimmer + Fade App Name
  // ------------------------------------------------------------------
  Widget _animatedAppName() {
    return FadeTransition(
      opacity: _textFade,
      child: AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, _) {
          return ShaderMask(
            shaderCallback: (bounds) {
              final pos = _shimmerController.value * bounds.width;
              return LinearGradient(
                colors: const [
                  Colors.white,
                  Color(0xFFCCEFFF),
                  Colors.white,
                ],
                stops: [
                  (pos - bounds.width) / bounds.width,
                  pos / bounds.width,
                  (pos + bounds.width) / bounds.width,
                ],
              ).createShader(bounds);
            },
            child: Text(
              AppConstants.appName,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------------
  // 🌟 Tagline Fade-Up
  // ------------------------------------------------------------------
  Widget _animatedTagline() {
    return FadeTransition(
      opacity: _taglineFadeUp,
      child: Transform.translate(
        offset: Offset(0, 20 * (1 - _taglineFadeUp.value)),
        child: Text(
          "Delicious food, delivered fast.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.75),
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// 🔹 Particle Class (floating dots)
// ------------------------------------------------------------------
class _Particle {
  double x = 0;
  double y = 0;
  double speed = 0.5;
  double size = 2;
  double opacity = 0.4;

  _Particle.random() {
    final rand = Random();
    x = rand.nextDouble() * 400;
    y = rand.nextDouble() * 800;
    speed = 0.4 + rand.nextDouble() * 1.2;
    size = 2 + rand.nextDouble() * 3;
    opacity = 0.2 + rand.nextDouble() * 0.5;
  }

  void update() {
    y -= speed;
    if (y < -10) {
      y = 820;
    }
  }
}
