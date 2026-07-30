import '../result/result.dart';

/// Marker type for a Use Case that takes no parameters.
final class NoParams {
  const NoParams();
}

/// Base contract for every one-shot (Future-based) Use Case in the
/// Application layer. Callable via `call()`.
abstract class UseCase<Type, Params> {
  const UseCase();

  Future<Result<Type>> call(Params params);
}