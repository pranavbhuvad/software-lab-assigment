import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/auth_models.dart';
import '../../domain/state/auth_state.dart';
import '../repositories/auth_repository.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.read(authRepositoryProvider));
});

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthController(this._repository) : super(const AuthState());

  void resetState() => state = const AuthState();

  Future<bool> login(LoginRequest request) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _repository.login(request);
      state = state.copyWith(status: AuthStatus.success, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
      return false;
    }
  }

  Future<bool> register(RegisterRequest request) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _repository.register(request);
      state = state.copyWith(status: AuthStatus.success, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
      return false;
    }
  }

  Future<bool> forgotPassword(ForgotPasswordRequest request) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final msg = await _repository.forgotPassword(request);
      state = state.copyWith(
        status: AuthStatus.success,
        successMessage: msg,
      );
      return true;
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
      return false;
    }
  }

  Future<bool> verifyOtp(VerifyOtpRequest request) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final token = await _repository.verifyOtp(request);
      state = state.copyWith(
        status: AuthStatus.success,
        resetToken: token,
      );
      return true;
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
      return false;
    }
  }

  Future<bool> resetPassword(ResetPasswordRequest request) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final msg = await _repository.resetPassword(request);
      state = state.copyWith(
        status: AuthStatus.success,
        successMessage: msg,
      );
      return true;
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
      return false;
    }
  }
}