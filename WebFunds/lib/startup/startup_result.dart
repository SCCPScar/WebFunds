import '../features/auth/domain/entities/auth_user.dart';

/// The outcome of everything that must happen before the app can show
/// its first real screen. Immutable — see [StartupResultBuilder] for how
/// tasks contribute to it.
class StartupResult {
  const StartupResult({this.sessionUser});

  /// `null` when no session exists — the person must go through Login.
  final AuthUser? sessionUser;

  bool get hasSession => sessionUser != null;
}

/// Mutable accumulator every [StartupTask] writes into. Each task owns
/// its own field(s) and writes only to those — safe under `Future.wait`
/// because Dart's event loop never runs two tasks' code at the same
/// instant, even though their I/O overlaps.
///
/// Adding a startup task (Remote Config, Feature Flags, ...) means adding
/// a field here and setting it from the new task's `run()` — nothing that
/// reads [StartupResult] needs to change.
class StartupResultBuilder {
  AuthUser? sessionUser;

  StartupResult build() => StartupResult(sessionUser: sessionUser);
}