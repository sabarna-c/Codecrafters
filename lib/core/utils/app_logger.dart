import 'package:flutter/foundation.dart';

/// Centralized Logger for AlumniConnect+
class AppLogger {
  AppLogger._();

  static void info(String message, [String tag = 'INFO']) {
    if (kDebugMode) {
      debugPrint('🔵 [$tag] $message');
    }
  }

  static void warning(String message, [String tag = 'WARNING']) {
    if (kDebugMode) {
      debugPrint('⚠️ [$tag] $message');
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace, String tag = 'ERROR']) {
    if (kDebugMode) {
      debugPrint('🔴 [$tag] $message');
      if (error != null) debugPrint('    Details: $error');
      if (stackTrace != null) debugPrint('    StackTrace:\n$stackTrace');
    }
  }
}
