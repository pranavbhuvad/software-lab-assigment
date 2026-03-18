import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

abstract final class AppLogger {
  static void d(String tag, String message) =>
      _log(LogLevel.debug, tag, message);

  static void i(String tag, String message) =>
      _log(LogLevel.info, tag, message);

  static void w(String tag, String message) =>
      _log(LogLevel.warning, tag, message);

  static void e(String tag, String message, [Object? error, StackTrace? stack]) {
    _log(LogLevel.error, tag, message);
    if (error != null) debugPrint('[$tag] ERROR: $error');
    if (stack != null) debugPrint('[$tag] STACK: $stack');
  }

  static void _log(LogLevel level, String tag, String message) {
    if (!kDebugMode) return;
    final prefix = switch (level) {
      LogLevel.debug => '🔍 DEBUG',
      LogLevel.info => '✅ INFO',
      LogLevel.warning => '⚠️ WARN',
      LogLevel.error => '❌ ERROR',
    };
    debugPrint('$prefix [$tag] $message');
  }
}
