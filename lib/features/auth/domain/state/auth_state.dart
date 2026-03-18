import '../models/auth_models.dart';

enum AuthStatus { idle, loading, success, error }

class AuthState {
  final AuthStatus status;
  final AuthUser? user;
  final String? error;
  final String? successMessage;
  final String? resetToken; // token received after OTP verify

  const AuthState({
    this.status = AuthStatus.idle,
    this.user,
    this.error,
    this.successMessage,
    this.resetToken,
  });

  bool get isLoading => status == AuthStatus.loading;
  bool get hasError => status == AuthStatus.error;
  bool get isSuccess => status == AuthStatus.success;

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    String? error,
    String? successMessage,
    String? resetToken,
  }) =>
      AuthState(
        status: status ?? this.status,
        user: user ?? this.user,
        error: error,
        successMessage: successMessage ?? this.successMessage,
        resetToken: resetToken ?? this.resetToken,
      );
}