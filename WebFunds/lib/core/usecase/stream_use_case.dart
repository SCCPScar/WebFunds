import '../result/result.dart';

/// Base contract for a Use Case that exposes a continuous stream of
/// results instead of a single Future.
abstract class StreamUseCase<Type, Params> {
  const StreamUseCase();

  Stream<Result<Type>> call(Params params);
}