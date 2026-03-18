import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/storage/local_storage.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final storage = ref.read(localStorageProvider);
  return OnboardingRepository(storage);
});

class OnboardingRepository {
  final LocalStorage _storage;

  const OnboardingRepository(this._storage);

  Future<void> completeOnboarding() async {
    try {
      await _storage.setOnboardingDone();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  bool isOnboardingCompleted() {
    try {
      return _storage.isOnboardingDone();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
