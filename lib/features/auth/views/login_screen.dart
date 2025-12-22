// lib/features/auth/views/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../app/config/app_colors.dart';
import '../../../app/services/speech_service.dart';
import '../../../app/services/biometric_service.dart';
import '../../../app/services/native_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  
  late AnimationController _glowController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _glowController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    await NativeService.selectionHaptic();
    setState(() => _isLoading = true);
    
    // Simulate login process
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      await NativeService.heavyHaptic();
      await SpeechService.speak('Welcome back to FooDoko!');
      context.go('/home');
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _biometricLogin() async {
    await NativeService.selectionHaptic();
    final isAuthenticated = await BiometricService.authenticate();
    if (isAuthenticated && mounted) {
      await NativeService.heavyHaptic();
      await SpeechService.speak('Biometric authentication successful!');
      context.go('/home');
    }
  }

  Future<void> _voiceLogin() async {
    await NativeService.selectionHaptic();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _VoiceLoginDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepMidnight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // Animated Logo
                Center(
                  child: AnimatedBuilder(
                    animation: _glowController,
                    builder: (context, child) {
                      return Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.electricGreen.withValues(alpha: 0.3 + 0.2 * _glowController.value),
                              blurRadius: 30 + 10 * _glowController.value,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.fastfood_rounded,
                          size: 60,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ).animate().scale(delay: 200.ms),
                
                const SizedBox(height: 32),
                
                // Welcome Text
                Text(
                  'Welcome Back!',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
                
                const SizedBox(height: 8),
                
                Text(
                  'Sign in to continue your ultra food journey',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 600.ms),
                
                const SizedBox(height: 48),
                
                // Email Field
                _buildGlassTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Email is required';
                    if (!value!.contains('@')) return 'Invalid email format';
                    return null;
                  },
                ).animate().slideX(delay: 800.ms, begin: -0.3).fadeIn(),
                
                const SizedBox(height: 20),
                
                // Password Field
                _buildGlassTextField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white70,
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Password is required';
                    if (value!.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ).animate().slideX(delay: 1000.ms, begin: 0.3).fadeIn(),
                
                const SizedBox(height: 16),
                
                // Remember Me & Forgot Password
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) => setState(() => _rememberMe = value ?? false),
                      activeColor: AppColors.electricGreen,
                    ),
                    Text(
                      'Remember me',
                      style: GoogleFonts.inter(color: Colors.white70),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.inter(color: AppColors.electricGreen),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 1200.ms),
                
                const SizedBox(height: 32),
                
                // Login Button
                AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 2 * _floatController.value),
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.electricGreen.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'Sign In',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ).animate().scale(delay: 1400.ms),
                
                const SizedBox(height: 24),
                
                // Ultra Features
                Row(
                  children: [
                    Expanded(
                      child: _buildFeatureButton(
                        icon: Icons.fingerprint,
                        label: 'Biometric',
                        onTap: _biometricLogin,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFeatureButton(
                        icon: Icons.mic,
                        label: 'Voice Login',
                        onTap: _voiceLogin,
                      ),
                    ),
                  ],
                ).animate().slideY(delay: 1600.ms, begin: 0.3).fadeIn(),
                
                const SizedBox(height: 32),
                
                // Social Login
                Text(
                  'Or continue with',
                  style: GoogleFonts.inter(color: Colors.white70),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 1800.ms),
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(child: _buildSocialButton('Google', Icons.g_mobiledata)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildSocialButton('Apple', Icons.apple)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildSocialButton('Facebook', Icons.facebook)),
                  ],
                ).animate().slideY(delay: 2000.ms, begin: 0.2).fadeIn(),
                
                const SizedBox(height: 32),
                
                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.inter(color: Colors.white70),
                    ),
                    TextButton(
                      onPressed: () => context.push('/signup'),
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.inter(
                          color: AppColors.electricGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 2200.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: AppColors.glassGradient,
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        style: GoogleFonts.inter(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white70),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildFeatureButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.glassGradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.electricGreen, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(String name, IconData icon) {
    return GestureDetector(
      onTap: () async {
        await NativeService.selectionHaptic();
        await _socialLogin(name);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: AppColors.glassGradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: Colors.white70, size: 24),
      ),
    );
  }

  Future<void> _socialLogin(String provider) async {
    setState(() => _isLoading = true);
    
    await SpeechService.speak('Signing in with $provider');
    
    // Simulate social login
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      await NativeService.heavyHaptic();
      await SpeechService.speak('Successfully signed in with $provider!');
      context.go('/home');
    }
    
    setState(() => _isLoading = false);
  }
}

class _VoiceLoginDialog extends StatefulWidget {
  @override
  State<_VoiceLoginDialog> createState() => _VoiceLoginDialogState();
}

class _VoiceLoginDialogState extends State<_VoiceLoginDialog> with TickerProviderStateMixin {
  bool _isListening = false;
  String _voiceText = '';
  String _status = 'Initializing voice recognition...';
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    
    _startVoiceLogin();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    SpeechService.stop();
    super.dispose();
  }

  Future<void> _startVoiceLogin() async {
    await SpeechService.speak('Please say: Login with my voice');
    
    setState(() {
      _status = 'Listening... Say "Login with my voice"';
      _isListening = true;
    });

    await SpeechService.startListening(
      onResult: (text) {
        setState(() => _voiceText = text);
      },
    );
    
    await Future.delayed(const Duration(seconds: 5));
    await SpeechService.stopListening();
    
    setState(() => _isListening = false);

    if (_voiceText.toLowerCase().contains('login') || 
        _voiceText.toLowerCase().contains('sign in') ||
        _voiceText.toLowerCase().contains('voice')) {
      setState(() => _status = 'Voice recognized! Logging in...');
      await SpeechService.speak('Voice authentication successful!');
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        await NativeService.heavyHaptic();
        Navigator.pop(context);
        context.go('/home');
      }
    } else {
      setState(() => _status = 'Voice not recognized. Please try again.');
      await SpeechService.speak('Voice not recognized. Please try again.');
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.deepMidnight,
              AppColors.deepMidnight.withValues(alpha: 0.95),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.electricGreen.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Voice Login',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_pulseController.value * 0.2),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          _isListening ? AppColors.electricGreen : Colors.grey,
                          (_isListening ? AppColors.electricGreen : Colors.grey).withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                    child: Icon(
                      _isListening ? Icons.mic : Icons.mic_off,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              _status,
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            if (_voiceText.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'You said: "${_voiceText.isNotEmpty ? _voiceText : 'Nothing detected'}"',
                  style: GoogleFonts.inter(
                    color: AppColors.electricGreen,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}