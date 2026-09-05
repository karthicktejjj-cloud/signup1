/// Base typed exception class for the application.
/// Ensures standard handling across UI without knowing exact backend schemas.
sealed class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => message;
}

/// Validation failure triggered before reaching the network or returned by API.
final class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    super.details,
  });
}

/// Network connectivity, DNS, or socket failure.
final class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Network connection error. Please check your internet connection.',
    super.code = 'NETWORK_ERROR',
    super.details,
  });
}

/// Request timed out.
final class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'The request timed out. Please try again.',
    super.code = 'TIMEOUT',
    super.details,
  });
}

/// 401 Unauthorized / Expired session.
final class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Session expired or invalid credentials.',
    super.code = 'UNAUTHORIZED',
    super.details,
  });
}

/// 5xx Server failure.
final class ServerException extends AppException {
  const ServerException({
    super.message = 'Server encountered an issue. Please try again later.',
    super.code = 'SERVER_ERROR',
    super.details,
  });
}

/// Unknown / fallback application error.
final class UnknownException extends AppException {
  const UnknownException({
    super.message = 'An unexpected error occurred. Please try again.',
    super.code = 'UNKNOWN',
    super.details,
  });
}
