import '../features/auth/domain/entities/auth_user.dart';

class StartupResult {
  const StartupResult({this.sessionUser});

  final AuthUser? sessionUser;

  bool get hasSession => sessionUser != null;
}

class StartupResultBuilder {
  AuthUser? sessionUser;

  StartupResult build() => StartupResult(sessionUser: sessionUser);
}
