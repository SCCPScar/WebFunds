import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/entities/dream.dart';
import '../../domain/repositories/dream_repository.dart';

class ArchiveDreamUseCase extends UseCase<Dream, String> {
  const ArchiveDreamUseCase(this._repository);

  final DreamRepository _repository;

  @override
  Future<Result<Dream>> call(String dreamId) => _repository.archive(dreamId);
}
