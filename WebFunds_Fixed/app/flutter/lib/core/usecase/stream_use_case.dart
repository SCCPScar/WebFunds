import '../result/result.dart';

abstract class StreamUseCase<Type, Params> {
  const StreamUseCase();

  Stream<Result<Type>> call(Params params);
}
