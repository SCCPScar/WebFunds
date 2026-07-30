import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/env_config.dart';
import '../logging/app_logger.dart';

class SupabaseService {
  SupabaseService(this._logger);

  final AppLogger _logger;

  bool _initialized = false;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (!EnvConfig.isSupabaseConfigured) {
      _logger.warning(
        'Supabase not configured (empty SUPABASE_URL/SUPABASE_ANON_KEY) — skipping initialize().',
        tag: 'Supabase',
      );
      return;
    }

    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
      debug: EnvConfig.environment.isDebuggable,
    );

    _initialized = true;
    _logger.info('Supabase initialized.', tag: 'Supabase');
  }

  SupabaseClient get client => Supabase.instance.client;

  User? get currentUser => _initialized ? client.auth.currentUser : null;
}

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService(ref.watch(appLoggerProvider));
});
