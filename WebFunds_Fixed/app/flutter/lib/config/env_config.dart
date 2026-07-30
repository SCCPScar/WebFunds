import 'environment.dart';

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
