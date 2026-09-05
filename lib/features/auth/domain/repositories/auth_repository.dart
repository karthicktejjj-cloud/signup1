import '../models/user_session.dart';

/// Clean abstract contract for Authentication.
/// Completely separates UI from backend communication mechanisms.
abstract interface class AuthRepository {
  Future<UserSession?> checkAuthStatus();

  Future<UserSession> login({
    required String email,
    required String password,
  });

  Future<void> register({
    required String name,
    required String email,
    required String password,
  });

  Future<UserSession> verifyOtp({
    required String email,
    required String otp,
    required String flowType, // 'signup' or 'reset'
  });

  Future<void> resendOtp({
    required String email,
  });

  Future<void> forgotPassword({
    required String email,
  });

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  Future<void> logout();
}
