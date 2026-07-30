/// WebFunds Failure hierarchy — what the Application/Domain layer works
/// with. Infrastructure code throws an [AppException] instead; repository
/// implementations catch it and map it to a [Failure] via
/// `failure_mapper.dart`. Plain Dart 3 sealed class (see ADR 005).
sealed class Failure {
  const Failure({required this.message, this.code});

  /// Short, user-presentable explanation — never a raw stack trace.
  final String message;

  /// Optional machine-readable code, useful for logging/tests only.
  final String? code;
}

/// The device has no usable network connection.
final class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Sem ligação à internet.', super.code});
}

/// The backend (Supabase / an Edge Function) returned an error.
final class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// A local cache/database (Drift) read or write failed.
final class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}

/// Authentication or session failure.
final class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

/// Input failed validation before ever reaching Infrastructure.
final class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

/// Anything that does not fit the categories above.
final class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'Algo correu mal.', super.code});
}