// lib/features/auth/repository/auth_repository.dart

import 'dart:async';


class AuthRepository {
  // Fake login: accepts any email with "@" and password length >= 6
  Future<void> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (!email.contains('@') || password.length < 6) {
      throw AuthException('Invalid email or password');
    }
    // success - do nothing (no backend)
  }

  // Fake signup: basic validation
  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (name.trim().isEmpty) throw AuthException('Please provide a name');
    if (!email.contains('@')) throw AuthException('Invalid email');
    if (password.length < 6) throw AuthException('Password too short');
    // success
  }

  // Fake password reset
  Future<void> sendPasswordReset({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (!email.contains('@')) throw AuthException('Invalid email');
    // success
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}
