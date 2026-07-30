/// The Domain-layer representation of an authenticated owner. Minimal —
/// WebFunds is a single-owner personal app, so this only carries what the
/// app needs to know someone is signed in.
class AuthUser {
  const AuthUser({required this.id, required this.email});

  final String id;
  final String email;
}