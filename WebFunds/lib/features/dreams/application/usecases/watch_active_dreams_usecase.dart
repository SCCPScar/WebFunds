import '../../../../core/result/result.dart';
import '../../domain/entities/dream.dart';
import '../../domain/repositories/dream_repository.dart';

class WatchActiveDreamsUseCase {
  const WatchActiveDreamsUseCase(this._repository);

  final DreamRepository _repository;

  Stream<Result<List<Dream>>> call() => _repository.watchActive();
}
