import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../shared/models/money.dart';
import '../../../transactions/domain/entities/transaction_type.dart';
import '../../application/usecases/suggest_category_usecase.dart';
import '../../domain/entities/category_suggestion.dart';
import 'weaver_providers.dart';

sealed class SuggestCategoryState {
  const SuggestCategoryState();
}

final class SuggestCategoryIdle extends SuggestCategoryState {
  const SuggestCategoryIdle();
}

final class SuggestCategoryLoading extends SuggestCategoryState {
  const SuggestCategoryLoading();
}

/// Weaver had nothing worth showing (e.g. Very Low confidence) — distinct
/// from `SuggestCategoryFailed`, which means the request itself failed.
final class SuggestCategoryEmpty extends SuggestCategoryState {
  const SuggestCategoryEmpty();
}

final class SuggestCategorySuccess extends SuggestCategoryState {
  const SuggestCategorySuccess(this.suggestion);
  final CategorySuggestion suggestion;
}

final class SuggestCategoryFailed extends SuggestCategoryState {
  const SuggestCategoryFailed(this.failure);
  final Failure failure;
}

/// `autoDispose` so a leftover suggestion never survives closing and
/// reopening the "add transaction" sheet.
final suggestCategoryControllerProvider =
    NotifierProvider.autoDispose<SuggestCategoryController, SuggestCategoryState>(
  SuggestCategoryController.new,
);

class SuggestCategoryController extends Notifier<SuggestCategoryState> {
  @override
  SuggestCategoryState build() => const SuggestCategoryIdle();

  Future<void> request({
    required TransactionType type,
    required Money amount,
    String? merchant,
  }) async {
    state = const SuggestCategoryLoading();

    final useCase = ref.read(suggestCategoryUseCaseProvider);
    final result = await useCase(
      SuggestCategoryParams(type: type, amount: amount, merchant: merchant),
    );

    state = switch (result) {
      Success<CategorySuggestion?>(:final data) =>
        data == null ? const SuggestCategoryEmpty() : SuggestCategorySuccess(data),
      ResultError<CategorySuggestion?>(:final failure) => SuggestCategoryFailed(failure),
    };
  }

  void reset() => state = const SuggestCategoryIdle();
}
