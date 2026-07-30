import 'environment.dart';

/// Runtime + compile-time environment configuration. [environment] is set
/// once at startup by whichever entry point ran. The actual secrets/URLs
/// are compile-time constants read via `String.fromEnvironment`, supplied
/// per environment with `--dart-define-from-file=env/development.json`.
class EnvConfig {
  const EnvConfig._();

  static AppEnvironment _environment = AppEnvironment.development;

  static AppEnvironment get environment => _environment;

  static void setEnvironment(AppEnvironment value) => _environment = value;

  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static const bool enableNetworkLogging = bool.fromEnvironment(
    'ENABLE_NETWORK_LOGGING',
    defaultValue: true,
  );

  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}