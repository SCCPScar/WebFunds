sealed class Failure {
  const Failure({required this.message, this.code});

  final String message;
  final String? code;
}

final class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Sem ligação à internet.', super.code});
}

final class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

final class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}

final class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

final class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

final class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'Algo correu mal.', super.code});
}
