import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

class UpdateTransactionMerchantCategoryParams {
  const UpdateTransactionMerchantCategoryParams({
    required this.id,
    this.merchant,
    this.category,
  });

  final String id;
  final String? merchant;
  final String? category;
}

class UpdateTransactionMerchantCategoryUseCase
    extends UseCase<Transaction, UpdateTransactionMerchantCategoryParams> {
  const UpdateTransactionMerchantCategoryUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<Transaction>> call(UpdateTransactionMerchantCategoryParams params) {
    return _repository.updateMerchantAndCategory(
      params.id,
      merchant: params.merchant,
      category: params.category,
    );
  }
}
