/// Centralized API endpoint constants.
///
/// NOTE FOR BACKEND DEVELOPER:
/// Connect your actual API routes and baseUrl here.
/// Do NOT hardcode endpoints anywhere else in the application.
abstract final class ApiEndpoints {
  // TODO: Set to client's actual backend base URL (e.g., https://api.clientdomain.com/v1)
  static const String baseUrl = 'https://api.placeholder.internal/v1';

  // Auth endpoints placeholder contracts
  // TODO: Replace with official backend route paths
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String currentUser = '/auth/me';
}
