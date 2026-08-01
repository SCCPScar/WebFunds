import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../../../shared/models/money.dart';
import '../../domain/entities/dream.dart';
import '../../domain/repositories/dream_repository.dart';

class CreateDreamParams {
  const CreateDreamParams({
    required this.name,
    required this.targetAmount,
    this.description,
    this.targetDate,
    this.category,
  });

  final String name;
  final Money targetAmount;
  final String? description;
  final DateTime? targetDate;
  final String? category;
}

class CreateDreamUseCase extends UseCase<Dream, CreateDreamParams> {
  const CreateDreamUseCase(this._repository);

  final DreamRepository _repository;

  @override
  Future<Result<Dream>> call(CreateDreamParams params) async {
    if (params.name.trim().isEmpty) {
      return const ResultError(ValidationFailure(message: 'O nome do objetivo é obrigatório.'));
    }
    if (!params.targetAmount.isPositive) {
      return const ResultError(
        ValidationFailure(message: 'O valor alvo tem de ser superior a zero.'),
      );
    }

    final description = params.description?.trim();
    final category = params.category?.trim();

    return _repository.create(
      name: params.name.trim(),
      targetAmount: params.targetAmount,
      description: description == null || description.isEmpty ? null : description,
      targetDate: params.targetDate,
      category: category == null || category.isEmpty ? null : category,
    );
  }
}
