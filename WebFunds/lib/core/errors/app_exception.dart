/// WebFunds exception hierarchy — the Infrastructure-layer counterpart to
/// [Failure]. Only Infrastructure code throws these; Application/Domain
/// work with `Result`/`Failure` instead.
sealed class AppException implements Exception {
  const AppException(this.message, {this.code, this.cause});

  final String message;
  final String? code;

  /// The original error this wraps, if any — kept only for logging.
  final Object? cause;

  @override
  String toString() => '$runtimeType: $message${code != null ? ' ($code)' : ''}';
}

final class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.cause});
}

final class ServerException extends AppException {
  const ServerException(super.message, {super.code, super.cause});
}

final class CacheException extends AppException {
  const CacheException(super.message, {super.code, super.cause});
}

final class AuthException extends AppException {
  const AuthException(super.message, {super.code, super.cause});
}

final class ValidationException extends AppException {
  const ValidationException(super.message, {super.code, super.cause});
}

final class BiometricException extends AppException {
  const BiometricException(super.message, {super.code, super.cause});
}

final class UnknownException extends AppException {
  const UnknownException(super.message, {super.code, super.cause});
}