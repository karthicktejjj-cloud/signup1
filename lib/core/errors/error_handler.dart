import 'package:dio/dio.dart';
import 'app_exception.dart';

/// Translates raw errors/exceptions into user-friendly typed AppExceptions.
/// Ready to inspect custom backend error payload shapes once provided.
abstract final class ErrorHandler {
  static AppException handle(dynamic error) {
    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      return _handleDioException(error);
    }

    return UnknownException(
      message: error?.toString() ?? 'An unexpected error occurred.',
    );
  }

  static AppException _handleDioException(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.badResponse:
        final statusCode = dioError.response?.statusCode;
        final data = dioError.response?.data;

        // Extract message gracefully if backend returns JSON
        String? message;
        if (data is Map<String, dynamic>) {
          message = data['message'] as String? ??
              data['error'] as String? ??
              data['detail'] as String?;
        }

        if (statusCode == 401 || statusCode == 403) {
          return UnauthorizedException(
            message: message ?? 'Unauthorized access. Please log in again.',
            details: data,
          );
        }

        if (statusCode != null && statusCode >= 500) {
          return ServerException(
            message: message ?? 'Server encountered an issue. Please try again later.',
            details: data,
          );
        }

        return ValidationException(
          message: message ?? 'Unable to process request. Please verify your input.',
          details: data,
        );

      case DioExceptionType.cancel:
        return const UnknownException(message: 'Request was cancelled.');

      default:
        return const NetworkException();
    }
  }
}
