import '../result/result.dart';

final class NoParams {
  const NoParams();
}

abstract class UseCase<Type, Params> {
  const UseCase();

  Future<Result<Type>> call(Params params);
}
