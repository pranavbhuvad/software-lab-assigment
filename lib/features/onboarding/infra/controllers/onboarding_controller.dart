import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/state/onboarding_state.dart';
import '../repositories/onboarding_repository.dart';

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  final repository = ref.read(onboardingRepositoryProvider);
  return OnboardingController(repository);
});

class OnboardingController extends StateNotifier<OnboardingState> {
  final OnboardingRepository _repository;

  OnboardingController(this._repository) : super(const OnboardingState());

  void onPageChanged(int index) {
    state = state.copyWith(currentPage: index);
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.completeOnboarding();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
