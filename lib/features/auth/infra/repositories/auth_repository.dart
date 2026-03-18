import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:software_lab/features/auth/domain/models/auth_models.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/network/network_client.dart';
import '../../../../core/storage/local_storage.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.read(networkClientProvider);
  final storage = ref.read(localStorageProvider);
  return AuthRepository(client, storage);
});

class AuthRepository {
  final NetworkClient _client;
  final LocalStorage _storage;

  const AuthRepository(this._client, this._storage);

  // POST /user/login
  Future<AuthUser> login(LoginRequest request) async {
    try {
      final data = await _client.post('/user/login', body: request.toJson());
      final user = AuthUser.fromJson(data);
      await _storage.setToken(user.token);
      return user;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // POST /user/register
  Future<AuthUser> register(RegisterRequest request) async {
    try {
      final data = await _client.post('/user/register', body: request.toJson());
      final user = AuthUser.fromJson(data);
      await _storage.setToken(user.token);
      return user;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // POST /user/forgot-password
  Future<String> forgotPassword(ForgotPasswordRequest request) async {
    try {
      final data = await _client.post(
        '/user/forgot-password',
        body: request.toJson(),
      );
      return data['message']?.toString() ?? 'OTP sent successfully.';
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // POST /user/verify-otp
  Future<String> verifyOtp(VerifyOtpRequest request) async {
    try {
      final data = await _client.post(
        '/user/verify-otp',
        body: request.toJson(),
      );
      // Backend returns a reset token after OTP verification
      return data['token']?.toString() ?? data['data']?['token']?.toString() ?? '';
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // POST /user/reset-password
  Future<String> resetPassword(ResetPasswordRequest request) async {
    try {
      final data = await _client.post(
        '/user/reset-password',
        body: request.toJson(),
      );
      return data['message']?.toString() ?? 'Password reset successfully.';
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}