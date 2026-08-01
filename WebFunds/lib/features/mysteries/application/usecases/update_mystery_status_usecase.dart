import '../../../../core/result/result.dart';
import '../../domain/entities/mystery.dart';
import '../../domain/entities/mystery_status.dart';
import '../../domain/repositories/mystery_repository.dart';

class UpdateMysteryStatusParams {
  const UpdateMysteryStatusParams({required this.id, required this.status});

  final String id;
  final MysteryStatus status;
}

/// Covers reopening a resolved Mystery and archiving one —
/// `docs/02-Domain/05-Mysteries.md`: "A resolved Mystery may be
/// reopened. The previous audit history remains intact."
class UpdateMysteryStatusUseCase {
  const UpdateMysteryStatusUseCase(this._repository);

  final MysteryRepository _repository;

  Future<Result<Mystery>> call(UpdateMysteryStatusParams params) {
    return _repository.updateStatus(params.id, params.status);
  }
}
