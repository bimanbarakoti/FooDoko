// lib/features/auth/views/forgot_password_screen.dart
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

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your email')));
      return;
    }
    final success = await ref.read(authNotifierProvider.notifier).resetPassword(email);
    final state = ref.read(authNotifierProvider);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset link (simulated) sent')));
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error ?? 'Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Stack(children: [
        Positioned.fill(child: Image.asset('assets/images/forest_bg.jpg', fit: BoxFit.cover)),
        Positioned.fill(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6), child: Container(color: Colors.black.withOpacity(0.25)))),
        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('Reset Password', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 16),
                FrostedContainer(
                  blur: 8,
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.all(18),
                  child: Column(children: [
                    InputField(controller: emailController, hint: 'Your email', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 12),
                    PrimaryButton(label: 'Send Reset Link', loading: authState.loading, onPressed: _sendReset),
                    const SizedBox(height: 8),
                    TextButton(onPressed: () => context.pop(), child: Text('Back to login', style: TextStyle(color: AppColors.electricGreen))),
                  ]),
                ),
              ]),
            ),
          ),
        )
      ]),
    );
  }
}
