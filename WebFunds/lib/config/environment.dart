/// The environment WebFunds is running in.
enum AppEnvironment {
  development,
  staging,
  production;

  bool get isDevelopment => this == AppEnvironment.development;
  bool get isStaging => this == AppEnvironment.staging;
  bool get isProduction => this == AppEnvironment.production;

  /// Whether verbose logging, debug banners, and other developer
  /// conveniences should be enabled.
  bool get isDebuggable => this != AppEnvironment.production;
}