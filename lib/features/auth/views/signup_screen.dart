// lib/features/auth/views/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/widgets/glass/frosted_container.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _phone = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(()=> _sending = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(()=> _sending = false);
    context.push('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepMidnight,
      body: SafeArea(
        child: Center(
          child: FrostedContainer(
            padding: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(18),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Sign up / OTP', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              TextField(controller: _phone, keyboardType: TextInputType.phone, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Phone', border: InputBorder.none)),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _sending ? null : _send, child: Text(_sending ? 'Sending...' : 'Send OTP'))),
            ]),
          ),
        ),
      ),
    );
  }
}
