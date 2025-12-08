// lib/features/auth/providers/auth_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_auth_repository.dart';
import '../data/models/user_model.dart';

/// Repository provider (singleton)
final authRepoProvider = Provider<MockAuthRepository>((ref) {
  return MockAuthRepository();
});

/// Auth state is AsyncValue<UserModel?>:
/// - AsyncValue.loading() when loading
/// - AsyncValue.data(user) when signed in (user may be null)
/// - AsyncValue.error(...) on errors
final authNotifierProvider =
StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>(
      (ref) {
    final repo = ref.watch(authRepoProvider);
    return AuthNotifier(repo: repo);
  },
);

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final MockAuthRepository repo;

  AuthNotifier({required this.repo}) : super(const AsyncValue.loading()) {
    // Try to load current user on creation
    loadCurrentUser();
  }

  /// Loads current user from repository (mock or real)
  Future<void> loadCurrentUser() async {
    state = const AsyncValue.loading();
    try {
      final user = await repo.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Login flow using phone (mock)
  Future<UserModel?> loginWithPhone(String phone) async {
    state = const AsyncValue.loading();
    try {
      final user = await repo.loginWithPhone(phone);
      state = AsyncValue.data(user);
      return user;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await repo.logout();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Send OTP (mock)
  Future<bool> sendOtp(String phone) async {
    // keep current state while sending
    try {
      final ok = await repo.sendOtp(phone);
      return ok;
    } catch (e, st) {
      // bubble up
      rethrow;
    }
  }

  /// Verify OTP (mock): returns the signed-in user
  Future<UserModel> verifyOtp(String phone, String code) async {
    state = const AsyncValue.loading();
    try {
      final user = await repo.verifyOtp(phone, code);
      state = AsyncValue.data(user);
      return user;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
