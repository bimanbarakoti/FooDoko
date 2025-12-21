// lib/features/auth/views/signup_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/widgets/glass/frosted_container.dart';
import 'package:foodoko/app/widgets/buttons/input_field.dart';
import 'package:foodoko/app/widgets/buttons/primary_button.dart';
import '../providers/auth_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:foodoko/app/config/app_colors.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});
  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _attemptSignup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final notifier = ref.read(authNotifierProvider.notifier);

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final success = await notifier.signup(name, email, password);
    final state = ref.read(authNotifierProvider);
    if (success) {
      // back to login
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created')));
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error ?? 'Signup failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/images/forest_bg.jpg', fit: BoxFit.cover)),
          Positioned.fill(
            child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6), child: Container(color: Colors.black.withOpacity(0.25))),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Create Account', style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white)),
                    const SizedBox(height: 18),

                    FrostedContainer(
                      blur: 8,
                      borderRadius: BorderRadius.circular(16),
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          InputField(controller: nameController, hint: 'Full name', icon: Icons.person_outline),
                          const SizedBox(height: 12),
                          InputField(controller: emailController, hint: 'Email', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                          const SizedBox(height: 12),
                          InputField(controller: passwordController, hint: 'Password (min 6 chars)', icon: Icons.lock_outline, obscure: true),
                          const SizedBox(height: 14),
                          PrimaryButton(label: 'Sign Up', loading: authState.loading, onPressed: _attemptSignup),
                          const SizedBox(height: 8),
                          TextButton(onPressed: () => context.pop(), child: Text('Back to login', style: TextStyle(color: AppColors.electricGreen)))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
