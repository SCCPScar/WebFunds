import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/env_config.dart';

/// WebFunds logging contract. Wraps `dart:developer`'s `log()` directly
/// instead of adding a new dependency for something the SDK already does
/// well.
abstract class AppLogger {
  void debug(String message, {String? tag});
  void info(String message, {String? tag});
  void warning(String message, {String? tag});
  void error(String message, {String? tag, Object? error, StackTrace? stackTrace});
}

class ConsoleAppLogger implements AppLogger {
  const ConsoleAppLogger();

  static const int _debugLevel = 500;
  static const int _infoLevel = 800;
  static const int _warningLevel = 900;
  static const int _errorLevel = 1000;

  @override
  void debug(String message, {String? tag}) {
    if (!EnvConfig.environment.isDebuggable) return;
    developer.log(message, name: tag ?? 'WebFunds', level: _debugLevel);
  }

  @override
  void info(String message, {String? tag}) {
    developer.log(message, name: tag ?? 'WebFunds', level: _infoLevel);
  }

  @override
  void warning(String message, {String? tag}) {
    developer.log(message, name: tag ?? 'WebFunds', level: _warningLevel);
  }

  @override
  void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: tag ?? 'WebFunds',
      level: _errorLevel,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

final appLoggerProvider = Provider<AppLogger>((ref) => const ConsoleAppLogger());