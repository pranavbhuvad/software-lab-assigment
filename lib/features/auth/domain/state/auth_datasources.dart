import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_client.dart';
import '../../domain/models/auth_models.dart';

// ── Provider ───────────────────────────────────────────────────
final authDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final client = ref.read(networkClientProvider);
  return AuthRemoteDatasource(client);
});

class AuthRemoteDatasource {
  final NetworkClient _client;

  AuthRemoteDatasource(this._client);

  // ── Register (multipart with file upload) ─────────────────────
  Future<AuthUser> register({
    required Map<String, String> fields,
    File? proofFile,
  }) async {
    final data = await _client.postMultipart(
      '/user/register',
      fields: fields,
      file: proofFile,
      fileField: 'registration_proof',
    );
    return AuthUser.fromJson(data);
  }

  // ── Login ─────────────────────────────────────────────────────
  Future<AuthUser> login(LoginRequest request) async {
    final data = await _client.post(
      '/user/login',
      body: request.toJson(),
    );
    return AuthUser.fromJson(data);
  }

  // ── Forgot Password ───────────────────────────────────────────
  Future<String> forgotPassword(ForgotPasswordRequest request) async {
    final data = await _client.post(
      '/user/forgot-password',
      body: request.toJson(),
    );
    return data['message']?.toString() ?? 'OTP sent successfully.';
  }

  // ── Verify OTP ────────────────────────────────────────────────
  Future<String> verifyOtp(VerifyOtpRequest request) async {
    final data = await _client.post(
      '/user/verify-otp',
      body: request.toJson(),
    );
    return data['token']?.toString() ??
        data['data']?['token']?.toString() ??
        '';
  }

  // ── Reset Password ────────────────────────────────────────────
  Future<String> resetPassword(ResetPasswordRequest request) async {
    final data = await _client.post(
      '/user/reset-password',
      body: request.toJson(),
    );
    return data['message']?.toString() ?? 'Password reset successfully.';
  }
}