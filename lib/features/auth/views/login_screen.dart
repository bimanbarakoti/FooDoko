// lib/features/auth/views/login_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/widgets/glass/frosted_container.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:foodoko/app/config/app_colors.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  double intensity = 0.45;
  double mood = 0.5;
  double sweetSavory = 0.5;

  late AnimationController _heatController;
  bool _showHeat = false;

  @override
  void initState() {
    super.initState();
    _heatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _heatController.dispose();
    super.dispose();
  }

  Future<void> _onThumbLogin() async {
    setState(() => _showHeat = true);
    _heatController.forward(from: 0);
    HapticFeedback.mediumImpact();

    await Future.delayed(const Duration(milliseconds: 900));

    _heatController.reverse();
    setState(() => _showHeat = false);

    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.deepMidnight,
      body: Stack(
        children: [
          /// Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/forest_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),

          /// Dynamic Blur Layer
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 6 + 20 * intensity,
                sigmaY: 6 + 20 * intensity,
              ),
              child: Container(
                color: Colors.black.withOpacity(
                  0.28 * (1 - (0.5 + 0.5 * mood)),
                ),
              ),
            ),
          ),

          /// UI Content
          SafeArea(
            child: SingleChildScrollView(
              reverse: true,
              padding: EdgeInsets.only(bottom: keyboard + 20, top: 20),
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  Text(
                    'Palate Calibration',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 18),

                  _buildSlider(
                    'Intensity',
                    'Whisper',
                    'Roar',
                    intensity,
                        (v) => setState(() => intensity = v),
                  ),

                  const SizedBox(height: 12),

                  _buildSlider(
                    'Mood',
                    'Wanderlust',
                    'Nostalgia',
                    mood,
                        (v) => setState(() => mood = v),
                  ),

                  const SizedBox(height: 12),

                  _buildSlider(
                    'Sweet/Savory',
                    'Dusk',
                    'Dawn',
                    sweetSavory,
                        (v) => setState(() => sweetSavory = v),
                  ),

                  const SizedBox(height: 24),

                  /// Fingerprint Login
                  GestureDetector(
                    onTap: _onThumbLogin,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        FrostedContainer(
                          blur: 10,
                          padding: const EdgeInsets.all(26),
                          borderRadius: BorderRadius.circular(32),
                          child: Icon(
                            Icons.fingerprint,
                            size: 64,
                            color: AppColors.electricGreen,
                          ),
                        ),

                        if (_showHeat)
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: _heatController,
                              builder: (_, __) {
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        AppColors.electricGreen
                                            .withOpacity(0.4 *
                                            _heatController.value),
                                        Colors.transparent
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () => context.push('/signup'),
                    child: Text(
                      'Sign in with OTP',
                      style: TextStyle(
                        color: AppColors.electricGreen,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(
      String label,
      String start,
      String end,
      double value,
      ValueChanged<double> onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(value * 100).round()}%',
                style: GoogleFonts.inter(color: Colors.white70),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Text(start,
                  style: GoogleFonts.inter(
                      color: Colors.white70, fontSize: 12)),
              const SizedBox(width: 8),

              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    activeTrackColor: AppColors.electricGreen,
                    thumbColor: AppColors.electricGreen,
                    inactiveTrackColor: Colors.white24,
                  ),
                  child: Slider(value: value, onChanged: onChanged),
                ),
              ),

              const SizedBox(width: 8),
              Text(end,
                  style: GoogleFonts.inter(
                      color: Colors.white70, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }
}
