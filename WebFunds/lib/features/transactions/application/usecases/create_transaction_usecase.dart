import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../../../shared/models/money.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_type.dart';
import '../../domain/repositories/transaction_repository.dart';

class CreateTransactionParams {
  const CreateTransactionParams({
    required this.financialCycleId,
    required this.accountId,
    required this.type,
    required this.amount,
    required this.transactionDate,
    this.merchant,
    this.category,
  });

  final String financialCycleId;
  final String accountId;
  final TransactionType type;
  final Money amount;
  final DateTime transactionDate;
  final String? merchant;
  final String? category;
}

class CreateTransactionUseCase extends UseCase<Transaction, CreateTransactionParams> {
  const CreateTransactionUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<Transaction>> call(CreateTransactionParams params) async {
    if (!params.amount.isPositive) {
      return const ResultError(
        ValidationFailure(message: 'O valor da transação tem de ser superior a zero.'),
      );
    }

    final merchant = params.merchant?.trim();
    final category = params.category?.trim();

    return _repository.create(
      financialCycleId: params.financialCycleId,
      accountId: params.accountId,
      type: params.type,
      amount: params.amount,
      transactionDate: params.transactionDate,
      merchant: merchant == null || merchant.isEmpty ? null : merchant,
      category: category == null || category.isEmpty ? null : category,
    );
  }
}
