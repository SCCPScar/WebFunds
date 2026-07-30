import 'app_exception.dart';
import 'failure.dart';

/// Maps an [AppException] (Infrastructure) into a [Failure]
/// (Application/Domain). Repository implementations are the intended
/// call site.
Failure mapExceptionToFailure(AppException exception) {
  return switch (exception) {
    NetworkException() => NetworkFailure(message: exception.message, code: exception.code),
    ServerException() => ServerFailure(message: exception.message, code: exception.code),
    CacheException() => CacheFailure(message: exception.message, code: exception.code),
    AuthException() => AuthFailure(message: exception.message, code: exception.code),
    BiometricException() => AuthFailure(message: exception.message, code: exception.code),
    ValidationException() => ValidationFailure(
      message: exception.message,
      code: exception.code,
    ),
    UnknownException() => UnknownFailure(message: exception.message, code: exception.code),
  };
}