import 'dart:developer';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:software_lab/core/errors/app_exception.dart';
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

  // ── POST /user/login ───────────────────────────────────────────
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

  // ── POST /user/register (JSON) — kept for social login ─────────
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

  Future<AuthUser> registerJson({required Map<String, dynamic> body}) async {
    try {
      log('┌─── REGISTER JSON REQUEST ───────────────────────────');
      body.forEach((key, value) {
        final display = key == 'password' ? '••••••••' : value;
        log('│ $key: $display');
      });
      log('└─────────────────────────────────────────────────────');

      final data = await _client.post('/user/register', body: body);

      log('┌─── REGISTER JSON RESPONSE ──────────────────────────');
      data.forEach((key, value) => log('│ $key: $value'));
      log('└─────────────────────────────────────────────────────');

      final user = AuthUser.fromJson(data);
      await _storage.setToken(user.token);
      return user;
    } catch (e) {
      log('✖ REGISTER ERROR: $e');
      throw ErrorHandler.handle(e);
    }
  }

  // ── POST /user/forgot-password ─────────────────────────────────
  Future<String> forgotPassword(ForgotPasswordRequest request) async {
  try {
    final data = await _client.post(
      '/user/forgot-password',
      body: request.toJson(),
    );

    log('FORGOT PASSWORD RESPONSE: $data');

    // ── Explicitly check success field ──────────────────
    final success = data['success'];
    final message = data['message']?.toString() ?? '';

    if (success == false) {
      throw AppException(
        message: message.isNotEmpty
            ? message
            : 'Could not send OTP. Please try again.',
        errorCode: 'API_ERROR',
      );
    }

    return message.isNotEmpty ? message : 'OTP sent successfully.';
  } catch (e) {
    throw ErrorHandler.handle(e);
  }
}

  // ── POST /user/verify-otp ──────────────────────────────────────
  Future<String> verifyOtp(VerifyOtpRequest request) async {
    try {
      final data = await _client.post(
        '/user/verify-otp',
        body: request.toJson(),
      );
      log(data.toString());

      return data['token']?.toString() ??
          data['data']?['token']?.toString() ??
          '';
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // ── POST /user/reset-password ──────────────────────────────────
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
