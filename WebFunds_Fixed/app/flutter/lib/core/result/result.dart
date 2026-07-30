import '../errors/failure.dart';

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isError => this is ResultError<T>;

  T? get dataOrNull => switch (this) {
    Success<T>(:final data) => data,
    ResultError<T>() => null,
  };

  Failure? get failureOrNull => switch (this) {
    Success<T>() => null,
    ResultError<T>(:final failure) => failure,
  };

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

final class ResultError<T> extends Result<T> {
  const ResultError(this.failure);

  final Failure failure;
}
