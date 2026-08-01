import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/errors/failure.dart';
import 'package:webfunds/core/result/result.dart';
import 'package:webfunds/features/transactions/domain/entities/transaction_type.dart';
import 'package:webfunds/features/weaver/application/usecases/suggest_category_usecase.dart';
import 'package:webfunds/features/weaver/domain/entities/category_suggestion.dart';
import 'package:webfunds/features/weaver/domain/entities/confidence_level.dart';
import 'package:webfunds/features/weaver/domain/repositories/weaver_repository.dart';
import 'package:webfunds/shared/models/money.dart';

class _StubWeaverRepository implements WeaverRepository {
  _StubWeaverRepository(this._result);
  final Result<CategorySuggestion> _result;

  @override
  Future<Result<CategorySuggestion>> suggestCategory({
    required TransactionType type,
    required Money amount,
    String? merchant,
  }) async => _result;
}

CategorySuggestion _suggestion(int confidenceScore) {
  return CategorySuggestion(
    category: 'Groceries',
    confidenceScore: confidenceScore,
    confidenceLevel: ConfidenceLevelFromScore.fromScore(confidenceScore),
    reasoning: 'Merchant matches previous grocery purchases.',
  );
}

void main() {
  test('returns the suggestion when confidence is not Very Low', () async {
    final useCase = SuggestCategoryUseCase(_StubWeaverRepository(Success(_suggestion(85))));

    final result = await useCase(
      SuggestCategoryParams(type: TransactionType.expense, amount: Money.fromMinorUnits(0)),
    );

    expect(result.isSuccess, isTrue);
    expect(result.dataOrNull?.category, 'Groceries');
  });

  test('filters out Very Low confidence suggestions into a null Success', () async {
    final useCase = SuggestCategoryUseCase(_StubWeaverRepository(Success(_suggestion(20))));

    final result = await useCase(
      SuggestCategoryParams(type: TransactionType.expense, amount: Money.fromMinorUnits(0)),
    );

    expect(result.isSuccess, isTrue);
    expect(result.dataOrNull, isNull);
  });

  test('propagates a repository failure', () async {
    final useCase = SuggestCategoryUseCase(
      _StubWeaverRepository(const ResultError(ServerFailure(message: 'Falha simulada.'))),
    );

    final result = await useCase(
      SuggestCategoryParams(type: TransactionType.expense, amount: Money.fromMinorUnits(0)),
    );

    expect(result.isError, isTrue);
  });
}
