import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/env_config.dart';
import '../logging/app_logger.dart';
import '../storage/secure_storage_service.dart';

/// Bridges `supabase_flutter`'s `LocalStorage` contract to
/// `SecureStorageService`. Without this, `Supabase.initialize()` falls
/// back to its own default — `SharedPreferencesLocalStorage` — which
/// persists the session (access + refresh token) unencrypted. This keeps
/// the session in the same Keychain/Keystore-backed storage the rest of
/// the app already uses for other secrets.
class _SecureSupabaseLocalStorage extends LocalStorage {
  const _SecureSupabaseLocalStorage(this._storage);

  final SecureStorageService _storage;

  static const _key = 'supabase.persisted_session';

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> hasAccessToken() async {
    return await _storage.read(key: _key) != null;
  }

  @override
  Future<String?> accessToken() {
    return _storage.read(key: _key);
  }

  @override
  Future<void> removePersistedSession() {
    return _storage.delete(key: _key);
  }

  @override
  Future<void> persistSession(String persistSessionString) {
    return _storage.write(key: _key, value: persistSessionString);
  }
}

/// Wraps `supabase_flutter` initialization and exposes the client. The
/// single seam Infrastructure-layer repositories go through — nothing
/// outside `lib/services/supabase/` should import `package:supabase_flutter`
/// directly.
class SupabaseService {
  SupabaseService(this._logger, this._secureStorage);

  final AppLogger _logger;
  final SecureStorageService _secureStorage;

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
      // `anonKey` was renamed to `publishableKey` in a recent
      // supabase_flutter release; `EnvConfig.supabaseAnonKey` keeps the
      // `SUPABASE_ANON_KEY` dart-define name to match the Supabase
      // dashboard's naming, even though it's passed to `publishableKey`.
      publishableKey: EnvConfig.supabaseAnonKey,
      debug: EnvConfig.environment.isDebuggable,
      authOptions: FlutterAuthClientOptions(
        localStorage: _SecureSupabaseLocalStorage(_secureStorage),
      ),
    );

    _initialized = true;
    _logger.info('Supabase initialized.', tag: 'Supabase');
  }

  SupabaseClient get client => Supabase.instance.client;

  User? get currentUser => _initialized ? client.auth.currentUser : null;
}

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService(ref.watch(appLoggerProvider), ref.watch(secureStorageServiceProvider));
});