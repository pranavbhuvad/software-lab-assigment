import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localStorageProvider = Provider<LocalStorage>((ref) {
  throw UnimplementedError('Initialize with SharedPreferences instance');
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override in main with SharedPreferences.getInstance()');
});

abstract final class StorageKeys {
  static const String token = 'auth_token';
  static const String onboardingDone = 'onboarding_done';
  static const String userId = 'user_id';
}

class LocalStorage {
  final SharedPreferences _prefs;

  LocalStorage(this._prefs);

  // Token
  String? getToken() => _prefs.getString(StorageKeys.token);
  Future<void> setToken(String token) => _prefs.setString(StorageKeys.token, token);
  Future<void> clearToken() => _prefs.remove(StorageKeys.token);

  // Onboarding
  bool isOnboardingDone() => _prefs.getBool(StorageKeys.onboardingDone) ?? false;
  Future<void> setOnboardingDone() => _prefs.setBool(StorageKeys.onboardingDone, true);

  // Clear all
  Future<void> clearAll() => _prefs.clear();
}
