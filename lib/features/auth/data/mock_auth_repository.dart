// lib/features/auth/data/mock_auth_repository.dart
import 'dart:async';
import 'package:foodoko/features/auth/data/models/user_model.dart';

class MockAuthRepository {
  // fake logged-in user
  UserModel? _user;

  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _user;
  }

  Future<UserModel> loginWithPhone(String phone) async {
    await Future.delayed(const Duration(seconds: 1));
    final user = UserModel(id: 'u_${DateTime.now().millisecondsSinceEpoch}', phone: phone, name: 'Foo Lover');
    _user = user;
    return user;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _user = null;
  }

  Future<bool> sendOtp(String phone) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return true;
  }

  Future<UserModel> verifyOtp(String phone, String code) async {
    await Future.delayed(const Duration(seconds: 1));
    final user = UserModel(id: 'u_${DateTime.now().millisecondsSinceEpoch}', phone: phone, name: 'FooDoko Fan');
    _user = user;
    return user;
  }
}
