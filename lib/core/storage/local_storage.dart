import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Providers ──────────────────────────────────────────────────
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
      'Override in main with SharedPreferences.getInstance()');
});

final localStorageProvider = Provider<LocalStorage>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return LocalStorage(prefs);
});

// ── Storage Keys ───────────────────────────────────────────────
abstract final class StorageKeys {
  static const String token          = 'auth_token';   // used by NetworkClient
  static const String authToken      = 'auth_token';   // alias — same key
  static const String deviceToken    = 'device_token';
  static const String onboardingDone = 'onboarding_done';
  static const String userId         = 'user_id';
}

// ── LocalStorage ───────────────────────────────────────────────
class LocalStorage {
  final SharedPreferences _prefs;

  LocalStorage(this._prefs);

  // ── Token ────────────────────────────────────────────────────
  String? getToken()                    => _prefs.getString(StorageKeys.token);
  Future<void> setToken(String token)   => _prefs.setString(StorageKeys.token, token);
  Future<void> clearToken()             => _prefs.remove(StorageKeys.token);

  // ── Device Token ─────────────────────────────────────────────
  String? getDeviceToken()                         => _prefs.getString(StorageKeys.deviceToken);
  Future<void> saveDeviceToken(String token)       => _prefs.setString(StorageKeys.deviceToken, token);

  // ── Onboarding ───────────────────────────────────────────────
  bool isOnboardingDone()          => _prefs.getBool(StorageKeys.onboardingDone) ?? false;
  Future<void> setOnboardingDone() => _prefs.setBool(StorageKeys.onboardingDone, true);

  // ── User ID ──────────────────────────────────────────────────
  String? getUserId()                       => _prefs.getString(StorageKeys.userId);
  Future<void> setUserId(String id)         => _prefs.setString(StorageKeys.userId, id);

  // ── Clear ────────────────────────────────────────────────────
  Future<void> clearAll() => _prefs.clear();
}