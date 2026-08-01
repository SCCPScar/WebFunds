import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../shared/models/money.dart';
import '../../application/usecases/add_dream_contribution_usecase.dart';
import '../../application/usecases/add_dream_withdrawal_usecase.dart';
import '../../domain/entities/dream.dart';
import '../../domain/entities/dream_movement_type.dart';
import 'dream_providers.dart';

sealed class DreamMovementState {
  const DreamMovementState();
}

final class DreamMovementIdle extends DreamMovementState {
  const DreamMovementIdle();
}

final class DreamMovementLoading extends DreamMovementState {
  const DreamMovementLoading();
}

final class DreamMovementSuccess extends DreamMovementState {
  const DreamMovementSuccess(this.dream);
  final Dream dream;
}

final class DreamMovementFailed extends DreamMovementState {
  const DreamMovementFailed(this.failure);
  final Failure failure;
}

/// Handles both contributions and withdrawals — the two Use Cases share
/// identical shape (amount + notes against one Dream), so one
/// `autoDispose` controller (reset on close, same as
/// `suggestCategoryControllerProvider`) covers both instead of two
/// near-duplicate controllers.
final dreamMovementControllerProvider =
    NotifierProvider.autoDispose<DreamMovementController, DreamMovementState>(
  DreamMovementController.new,
);

class DreamMovementController extends Notifier<DreamMovementState> {
  @override
  DreamMovementState build() => const DreamMovementIdle();

  Future<void> submit({
    required String dreamId,
    required DreamMovementType type,
    required Money amount,
    String? notes,
  }) async {
    state = const DreamMovementLoading();

    final result = switch (type) {
      DreamMovementType.contribution => await ref.read(addDreamContributionUseCaseProvider).call(
          AddDreamContributionParams(dreamId: dreamId, amount: amount, notes: notes),
        ),
      DreamMovementType.withdrawal => await ref.read(addDreamWithdrawalUseCaseProvider).call(
          AddDreamWithdrawalParams(dreamId: dreamId, amount: amount, notes: notes),
        ),
    };

    state = switch (result) {
      Success<Dream>(:final data) => DreamMovementSuccess(data),
      ResultError<Dream>(:final failure) => DreamMovementFailed(failure),
    };
  }

  void reset() => state = const DreamMovementIdle();
}
