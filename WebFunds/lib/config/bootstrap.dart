import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app.dart';
import '../services/logging/app_logger.dart';
import '../services/supabase/supabase_service.dart';
import 'environment.dart';
import 'env_config.dart';

/// Shared startup sequence for every environment. `SupabaseService.initialize()`
/// runs here — safe even when `env/*.json` is empty, since it detects
/// "not configured" and returns without throwing. A `ProviderContainer`
/// is created manually so we can `await` this before the first frame.
///
/// Everything runs inside `runZonedGuarded` with `FlutterError.onError` and
/// `PlatformDispatcher.instance.onError` wired to `AppLogger`, so no error
/// — during startup or afterwards — is ever silently lost.
Future<void> bootstrapApp(AppEnvironment environment) async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Networks that can't reach fonts.gstatic.com (corporate firewalls,
      // some regions, blockers) left every piece of app text invisible —
      // google_fonts silently drops glyphs it can't fetch instead of
      // falling back. This makes it use the bundled/system font instead.
      GoogleFonts.config.allowRuntimeFetching = false;

      EnvConfig.setEnvironment(environment);

      final container = ProviderContainer();
      final logger = container.read(appLoggerProvider);

      FlutterError.onError = (FlutterErrorDetails details) {
        logger.error(
          'Unhandled Flutter framework error.',
          tag: 'FlutterError',
          error: details.exception,
          stackTrace: details.stack,
        );
      };

      PlatformDispatcher.instance.onError = (Object error, StackTrace stackTrace) {
        logger.error(
          'Unhandled platform error.',
          tag: 'PlatformDispatcher',
          error: error,
          stackTrace: stackTrace,
        );
        return true;
      };

      try {
        await container.read(supabaseServiceProvider).initialize();
      } catch (error, stackTrace) {
        logger.error(
          'Supabase failed to initialize during startup — continuing without a remote session.',
          tag: 'Bootstrap',
          error: error,
          stackTrace: stackTrace,
        );
      }

      runApp(
        UncontrolledProviderScope(
          container: container,
          child: const WebFundsApp(),
        ),
      );
    },
    (error, stackTrace) {
      // Last-resort handler for errors escaping the zone above (e.g.
      // before the logger exists). Mirrors ConsoleAppLogger.error() to
      // stay consistent without depending on a provider that may not be
      // reachable at this point.
      developer.log(
        'Unhandled zone error during startup.',
        name: 'Bootstrap',
        level: 1000,
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
}
