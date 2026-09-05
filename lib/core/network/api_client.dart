import 'package:dio/dio.dart';
import 'api_endpoints.dart';
import 'auth_interceptor.dart';
import '../storage/secure_storage_service.dart';

/// Configured Dio singleton/provider factory.
/// Enforces sensible timeouts, JSON headers, and interceptor architecture.
class ApiClient {
  late final Dio dio;

  ApiClient({
    required SecureStorageService storageService,
    String? customBaseUrl,
  }) {
    final options = BaseOptions(
      baseUrl: customBaseUrl ?? ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    dio = Dio(options);
    dio.interceptors.addAll([
      AuthInterceptor(storage: storageService),
      // In debug mode, could optionally add LogInterceptor if desired
    ]);
  }
}
