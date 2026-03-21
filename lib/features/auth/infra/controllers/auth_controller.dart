import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/auth_models.dart';
import '../../domain/state/auth_state.dart';
import '../repositories/auth_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Existing AuthController — UNCHANGED
// ─────────────────────────────────────────────────────────────────────────────

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(ref.read(authRepositoryProvider));
  },
);

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
      state = state.copyWith(status: AuthStatus.success, successMessage: msg);
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
      state = state.copyWith(status: AuthStatus.success, resetToken: token);
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
      state = state.copyWith(status: AuthStatus.success, successMessage: msg);
      return true;
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
      return false;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SignupState — multi-step form state
// ─────────────────────────────────────────────────────────────────────────────

class SignupState {
  final int step;
  final bool isLoading;
  final String? error;
  final bool isSuccess;
  final Map<String, dynamic> formData;
  final File? proofFile;
  final Map<String, List<String>> businessHours;

  const SignupState({
    this.step = 0,
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
    this.formData = const {},
    this.proofFile,
    this.businessHours = const {},
  });

  SignupState copyWith({
    int? step,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool? isSuccess,
    Map<String, dynamic>? formData,
    File? proofFile,
    bool clearProof = false,
    Map<String, List<String>>? businessHours,
  }) {
    return SignupState(
      step: step ?? this.step,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
      formData: formData ?? this.formData,
      proofFile: clearProof ? null : proofFile ?? this.proofFile,
      businessHours: businessHours ?? this.businessHours,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Available time slots and week days
// ─────────────────────────────────────────────────────────────────────────────

abstract final class TimeSlots {
  static const List<String> all = [
    '8:00am - 10:00am',
    '10:00am - 1:00pm',
    '1:00pm - 4:00pm',
    '4:00pm - 7:00pm',
    '7:00pm - 10:00pm',
  ];
}

abstract final class WeekDays {
  static const List<String> keys = [
    'mon',
    'tue',
    'wed',
    'thu',
    'fri',
    'sat',
    'sun',
  ];
  static const List<String> labels = ['M', 'T', 'W', 'Th', 'F', 'S', 'Su'];
}

// ─────────────────────────────────────────────────────────────────────────────
// SignupController — drives the 4-step signup flow
// ─────────────────────────────────────────────────────────────────────────────

final signupControllerProvider =
    StateNotifierProvider<SignupController, SignupState>((ref) {
      return SignupController(ref.read(authRepositoryProvider));
    });

class SignupController extends StateNotifier<SignupState> {
  final AuthRepository _repo;

  SignupController(this._repo) : super(const SignupState());

  void clearError() => state = state.copyWith(clearError: true);

  void updateField(String key, dynamic value) {
    final updated = Map<String, dynamic>.from(state.formData);
    updated[key] = value;
    state = state.copyWith(formData: updated, clearError: true);
  }

  void nextStep() {
    if (state.step < 3) {
      state = state.copyWith(step: state.step + 1, clearError: true);
    }
  }

  void prevStep() {
    if (state.step > 0) {
      state = state.copyWith(step: state.step - 1, clearError: true);
    }
  }

  void setProofFile(File file) =>
      state = state.copyWith(proofFile: file, clearError: true);

  void clearProofFile() =>
      state = state.copyWith(clearProof: true, clearError: true);

  void toggleTimeSlot(String day, String slot) {
    final updated = Map<String, List<String>>.from(
      state.businessHours.map((k, v) => MapEntry(k, List<String>.from(v))),
    );
    final slots = List<String>.from(updated[day] ?? []);
    slots.contains(slot) ? slots.remove(slot) : slots.add(slot);
    updated[day] = slots;
    state = state.copyWith(businessHours: updated, clearError: true);
  }

  Future<bool> submit() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final f = state.formData;

      final body = <String, dynamic>{
        'full_name': f['full_name'] ?? '',
        'email': f['email'] ?? '',
        'phone': f['phone'] ?? '',
        'password': f['password'] ?? '',
        'role': 'farmer',
        'business_name': f['business_name'] ?? '',
        'informal_name': f['informal_name'] ?? '',
        'address': f['address'] ?? '',
        'city': f['city'] ?? '',
        'state': f['state'] ?? '',
        'zip_code': f['zip_code'] ?? '',
        'registration_proof': 'my_proof.pdf',
        'business_hours': state.businessHours,
        'device_token': 'dummy_device_token',
        'type': 'email/facebook/google/apple',
        'social_id': 'dummy_social_id',
      };

      // ✅ JSON POST — not multipart
      await _repo.registerJson(body: body);

      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e
            .toString()
            .replaceAll('AppException(API_ERROR): ', '')
            .replaceAll('AppException(UNAUTHORIZED): ', '')
            .replaceAll('AppException(REQUEST_ERROR): ', ''),
      );
      return false;
    }
  }
}
