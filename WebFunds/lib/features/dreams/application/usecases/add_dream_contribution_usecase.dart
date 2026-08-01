import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../../../shared/models/money.dart';
import '../../domain/entities/dream.dart';
import '../../domain/repositories/dream_repository.dart';

class AddDreamContributionParams {
  const AddDreamContributionParams({required this.dreamId, required this.amount, this.notes});

  final String dreamId;
  final Money amount;
  final String? notes;
}

class AddDreamContributionUseCase extends UseCase<Dream, AddDreamContributionParams> {
  const AddDreamContributionUseCase(this._repository);

  final DreamRepository _repository;

  @override
  Future<Result<Dream>> call(AddDreamContributionParams params) async {
    if (!params.amount.isPositive) {
      return const ResultError(
        ValidationFailure(message: 'O valor da contribuição tem de ser superior a zero.'),
      );
    }
    final notes = params.notes?.trim();
    return _repository.addContribution(
      dreamId: params.dreamId,
      amount: params.amount,
      notes: notes == null || notes.isEmpty ? null : notes,
    );
  }
}
