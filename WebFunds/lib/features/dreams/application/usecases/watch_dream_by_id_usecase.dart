import '../../../../core/result/result.dart';
import '../../domain/entities/dream.dart';
import '../../domain/repositories/dream_repository.dart';

class WatchDreamByIdUseCase {
  const WatchDreamByIdUseCase(this._repository);

  final DreamRepository _repository;

  Stream<Result<Dream?>> call(String dreamId) => _repository.watchById(dreamId);
}
