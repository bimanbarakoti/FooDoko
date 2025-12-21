// lib/features/auth/providers/auth_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodoko/features/auth/data/mock_auth_repository.dart';

// simple state to represent loading/error
class AuthState {
  final bool loading;
  final String? error;
  AuthState({this.loading = false, this.error});
  AuthState copyWith({bool? loading, String? error}) =>
      AuthState(loading: loading ?? this.loading, error: error);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository repo;
  AuthNotifier(this.repo) : super(AuthState());

  Future<bool> login(String email, String password) async {
    try {
      state = state.copyWith(loading: true, error: null);
      await repo.login(email: email, password: password);
      state = state.copyWith(loading: false, error: null);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    try {
      state = state.copyWith(loading: true, error: null);
      await repo.signup(name: name, email: email, password: password);
      state = state.copyWith(loading: false, error: null);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      state = state.copyWith(loading: true, error: null);
      await repo.sendPasswordReset(email: email);
      state = state.copyWith(loading: false, error: null);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return false;
    }
  }

  void clearError() => state = state.copyWith(error: null);
}

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository());
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
      (ref) => AuthNotifier(ref.read(authRepositoryProvider)),
);
