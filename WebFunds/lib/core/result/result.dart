import '../errors/failure.dart';

/// The outcome of any operation that can fail — the return type of every
/// Use Case and every Repository method in WebFunds. Plain Dart 3 sealed
/// class (see ADR 005).
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isError => this is ResultError<T>;

  /// Returns the success value, or `null` if this is a [ResultError].
  T? get dataOrNull => switch (this) {
    Success<T>(:final data) => data,
    ResultError<T>() => null,
  };

  /// Returns the failure, or `null` if this is a [Success].
  Failure? get failureOrNull => switch (this) {
    Success<T>() => null,
    ResultError<T>(:final failure) => failure,
  };

  /// Collapses both branches into a single value of type [R].
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onError,
  }) {
    return switch (this) {
      Success<T>(:final data) => onSuccess(data),
      ResultError<T>(:final failure) => onError(failure),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

/// Named `ResultError`, not `Error`, to avoid colliding with `dart:core`'s
/// `Error` class.
final class ResultError<T> extends Result<T> {
  const ResultError(this.failure);

  final Failure failure;
}