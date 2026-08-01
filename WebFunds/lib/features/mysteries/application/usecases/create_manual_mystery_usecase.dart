import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/entities/mystery.dart';
import '../../domain/entities/mystery_reason.dart';
import '../../domain/repositories/mystery_repository.dart';

class CreateManualMysteryParams {
  const CreateManualMysteryParams({required this.transactionId, this.notes});

  final String transactionId;
  final String? notes;
}

/// `docs/02-Domain/05-Mysteries.md`: "The owner may manually create a
/// Mystery. ... Manual Mysteries behave exactly like automatic Mysteries."
class CreateManualMysteryUseCase extends UseCase<Mystery, CreateManualMysteryParams> {
  const CreateManualMysteryUseCase(this._repository);

  final MysteryRepository _repository;

  @override
  Future<Result<Mystery>> call(CreateManualMysteryParams params) {
    final notes = params.notes?.trim();
    return _repository.create(
      transactionId: params.transactionId,
      reason: MysteryReason.manual,
      notes: notes == null || notes.isEmpty ? null : notes,
    );
  }
}
