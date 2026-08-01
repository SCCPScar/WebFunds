import '../../../../core/result/result.dart';
import '../../domain/entities/dream_movement.dart';
import '../../domain/repositories/dream_repository.dart';

class WatchDreamMovementsUseCase {
  const WatchDreamMovementsUseCase(this._repository);

  final DreamRepository _repository;

  Stream<Result<List<DreamMovement>>> call(String dreamId) => _repository.watchMovements(dreamId);
}
