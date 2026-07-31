import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../shared/models/money.dart';
import '../../application/usecases/create_transaction_usecase.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_type.dart';
import 'transaction_providers.dart';

sealed class CreateTransactionState {
  const CreateTransactionState();
}

final class CreateTransactionIdle extends CreateTransactionState {
  const CreateTransactionIdle();
}

final class CreateTransactionLoading extends CreateTransactionState {
  const CreateTransactionLoading();
}

final class CreateTransactionSuccess extends CreateTransactionState {
  const CreateTransactionSuccess(this.transaction);
  final Transaction transaction;
}

final class CreateTransactionFailed extends CreateTransactionState {
  const CreateTransactionFailed(this.failure);
  final Failure failure;
}

final createTransactionControllerProvider =
    NotifierProvider<CreateTransactionController, CreateTransactionState>(
  CreateTransactionController.new,
);

class CreateTransactionController extends Notifier<CreateTransactionState> {
  @override
  CreateTransactionState build() => const CreateTransactionIdle();

  Future<void> submit({
    required String financialCycleId,
    required String accountId,
    required TransactionType type,
    required Money amount,
    required DateTime transactionDate,
    String? merchant,
    String? category,
  }) async {
    state = const CreateTransactionLoading();

    final useCase = ref.read(createTransactionUseCaseProvider);
    final result = await useCase(
      CreateTransactionParams(
        financialCycleId: financialCycleId,
        accountId: accountId,
        type: type,
        amount: amount,
        transactionDate: transactionDate,
        merchant: merchant,
        category: category,
      ),
    );

    state = switch (result) {
      Success<Transaction>(:final data) => CreateTransactionSuccess(data),
      ResultError<Transaction>(:final failure) => CreateTransactionFailed(failure),
    };
  }

  void reset() => state = const CreateTransactionIdle();
}
