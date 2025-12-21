// lib/features/auth/views/login_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/widgets/glass/frosted_container.dart';
import 'package:foodoko/app/widgets/buttons/input_field.dart';
import 'package:foodoko/app/widgets/buttons/primary_button.dart';
import '../providers/auth_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:foodoko/app/config/app_colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  late AnimationController _bgController;
  late AnimationController _pulseController;
  late Animation<double> _pulse;
  
  // Floating particles
  final List<_Particle> particles = [];

  @override
  void initState() {
    super.initState();
    
    // Init particles
    for (int i = 0; i < 15; i++) {
      particles.add(_Particle.random());
    }
    
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _bgController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _attemptLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final notifier = ref.read(authNotifierProvider.notifier);

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final success = await notifier.login(email, password);
    final state = ref.read(authNotifierProvider);
    if (success) {
      // navigate to home
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error ?? 'Login failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.deepMidnight,
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) {
          return Stack(
            children: [
              _animatedBackground(),
              _particleLayer(),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _logoPulse(),
                        const SizedBox(height: 20),
                        Text('Welcome Back', 
                          style: GoogleFonts.poppins(
                            fontSize: 28, 
                            fontWeight: FontWeight.w700, 
                            color: Colors.white
                          )
                        ),
                        const SizedBox(height: 8),
                        Text('Sign in to continue', 
                          style: GoogleFonts.inter(color: Colors.white70)
                        ),
                        const SizedBox(height: 28),

                        FrostedContainer(
                          blur: 8,
                          borderRadius: BorderRadius.circular(16),
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            children: [
                              InputField(
                                controller: emailController, 
                                hint: 'Email', 
                                icon: Icons.email_outlined, 
                                keyboardType: TextInputType.emailAddress
                              ),
                              const SizedBox(height: 12),
                              InputField(
                                controller: passwordController, 
                                hint: 'Password', 
                                icon: Icons.lock_outline, 
                                obscure: true
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => context.push('/forgot-password'),
                                  child: Text('Forgot password?', 
                                    style: TextStyle(color: AppColors.electricGreen)
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              PrimaryButton(
                                label: 'Login',
                                loading: authState.loading,
                                onPressed: _attemptLogin,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?", 
                              style: GoogleFonts.inter(color: Colors.white70)
                            ),
                            TextButton(
                              onPressed: () => context.push('/signup'), 
                              child: Text('Sign Up', 
                                style: TextStyle(color: AppColors.electricGreen)
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
  
  // Same background as splash screen
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
  
  // Floating particles like splash screen
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
  
  // Logo with pulse effect
  Widget _logoPulse() {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) {
        return Container(
          width: 80 + 8 * _pulse.value,
          height: 80 + 8 * _pulse.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.3 + 0.2 * _pulse.value),
                blurRadius: 30 + 8 * _pulse.value,
                spreadRadius: 3 + 2 * _pulse.value,
              )
            ],
          ),
          child: const Icon(Icons.fastfood_rounded,
              size: 35, color: Colors.white),
        );
      },
    );
  }
}

// Particle class for floating animation
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
