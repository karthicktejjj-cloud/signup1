import 'package:dio/dio.dart';
import '../storage/secure_storage_service.dart';
import '../storage/storage_keys.dart';

/// Interceptor designed to:
/// 1. Inject Bearer Access Token into headers
/// 2. Capture 401 Unauthorized responses to trigger token refresh or session termination
///
/// NOTE FOR BACKEND DEVELOPER:
/// Connect your specific refresh-token logic and token exchange protocol here.
class AuthInterceptor extends QueuedInterceptor {
  final SecureStorageService storage;

  AuthInterceptor({required this.storage});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Read cached token
    final token = await storage.read(StorageKeys.accessToken);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept'] = 'application/json';
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // If receiving 401 Unauthorized
    if (err.response?.statusCode == 401) {
      // TODO (Backend developer):
      // Implement automatic refresh token request flow:
      // 1. Read refreshToken from storage
      // 2. Call /auth/refresh
      // 3. Save new accessToken
      // 4. Retry original request
      // If refresh fails:
      // await storage.deleteAll();
    }
    return handler.next(err);
  }
}
