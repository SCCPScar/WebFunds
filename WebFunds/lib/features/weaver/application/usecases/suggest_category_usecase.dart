import '../../../../core/result/result.dart';
import '../../../../shared/models/money.dart';
import '../../../transactions/domain/entities/transaction_type.dart';
import '../../domain/entities/category_suggestion.dart';
import '../../domain/entities/confidence_level.dart';
import '../../domain/repositories/weaver_repository.dart';

class SuggestCategoryParams {
  const SuggestCategoryParams({required this.type, required this.amount, this.merchant});

  final TransactionType type;
  final Money amount;
  final String? merchant;
}

/// `docs/02-Domain/06-Weaver.md`: "Very Low suggestions should rarely be
/// displayed" — filtered out here so the Presentation layer never has to
/// know that rule. A `null` `Success` means "Weaver had nothing worth
/// showing", distinct from a `ResultError` (something actually failed).
class SuggestCategoryUseCase {
  const SuggestCategoryUseCase(this._repository);

  final WeaverRepository _repository;

  Future<Result<CategorySuggestion?>> call(SuggestCategoryParams params) async {
    final result = await _repository.suggestCategory(
      type: params.type,
      amount: params.amount,
      merchant: params.merchant,
    );

    return result.fold(
      onSuccess: (suggestion) => Success(
        suggestion.confidenceLevel == ConfidenceLevel.veryLow ? null : suggestion,
      ),
      onError: ResultError.new,
    );
  }
}
