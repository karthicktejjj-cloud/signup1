import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../domain/models/user_session.dart';
import '../../domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository.
///
/// NOTE FOR BACKEND INTEGRATION:
/// When backend contracts arrive:
/// 1. Inject ApiClient calls into the commented integration points below.
/// 2. Parse response DTOs and store real tokens via `storage`.
/// 3. Currently operates with clean frontend placeholder simulation without inventing fake endpoints.
class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  final SecureStorageService storage;

  AuthRepositoryImpl({
    required this.apiClient,
    required this.storage,
  });

  @override
  Future<UserSession?> checkAuthStatus() async {
    // Check if token and user session exist
    final token = await storage.read(StorageKeys.accessToken);
    final email = await storage.read(StorageKeys.userEmail);
    final userId = await storage.read(StorageKeys.userId);

    if (token != null && email != null) {
      return UserSession(
        id: userId ?? 'usr_local',
        email: email,
        displayName: email.split('@').first,
      );
    }
    return null;
  }

  @override
  Future<UserSession> login({
    required String email,
    required String password,
  }) async {
    // Simulating intentional UX response time
    await Future.delayed(const Duration(milliseconds: 900));

    // BACKEND INTEGRATION POINT:
    // final response = await apiClient.dio.post(ApiEndpoints.login, data: {'email': email, 'password': password});
    // final token = response.data['token'];
    // await storage.write(StorageKeys.accessToken, token);

    // Placeholder session setup:
    final session = UserSession(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: email.split('@').first,
    );

    await storage.write(StorageKeys.accessToken, 'placeholder_token');
    await storage.write(StorageKeys.userEmail, email);
    await storage.write(StorageKeys.userId, session.id);

    return session;
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    // BACKEND INTEGRATION POINT:
    // await apiClient.dio.post(ApiEndpoints.register, data: {'name': name, 'email': email, 'password': password});
  }

  @override
  Future<UserSession> verifyOtp({
    required String email,
    required String otp,
    required String flowType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    // BACKEND INTEGRATION POINT:
    // final response = await apiClient.dio.post(ApiEndpoints.verifyOtp, data: {'email': email, 'code': otp, 'type': flowType});

    final session = UserSession(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: email.split('@').first,
    );

    if (flowType == 'signup') {
      await storage.write(StorageKeys.accessToken, 'placeholder_token');
      await storage.write(StorageKeys.userEmail, email);
      await storage.write(StorageKeys.userId, session.id);
    }

    return session;
  }

  @override
  Future<void> resendOtp({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 700));

    // BACKEND INTEGRATION POINT:
    // await apiClient.dio.post(ApiEndpoints.resendOtp, data: {'email': email});
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // BACKEND INTEGRATION POINT:
    // await apiClient.dio.post(ApiEndpoints.forgotPassword, data: {'email': email});
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    // BACKEND INTEGRATION POINT:
    // await apiClient.dio.post(ApiEndpoints.resetPassword, data: {'email': email, 'otp': otp, 'newPassword': newPassword});
  }

  @override
  Future<void> logout() async {
    // BACKEND INTEGRATION POINT:
    // try { await apiClient.dio.post(ApiEndpoints.logout); } catch (_) {}

    await storage.delete(StorageKeys.accessToken);
    await storage.delete(StorageKeys.refreshToken);
    await storage.delete(StorageKeys.userId);
    await storage.delete(StorageKeys.userEmail);
  }
}
