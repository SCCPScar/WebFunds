import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../../transactions/application/usecases/update_transaction_merchant_category_usecase.dart';
import '../../domain/entities/mystery.dart';
import '../../domain/entities/mystery_status.dart';
import '../../domain/repositories/mystery_repository.dart';

class ResolveMysteryParams {
  const ResolveMysteryParams({
    required this.mysteryId,
    required this.transactionId,
    required this.merchant,
    required this.category,
    this.notes,
  });

  final String mysteryId;
  final String transactionId;

  /// Always applied together, like Finances' own edit sheet — the
  /// underlying Use Case overwrites both fields unconditionally, so a
  /// caller must resolve with the *final* value for each, not a partial
  /// change to just one.
  final String? merchant;
  final String? category;
  final String? notes;
}

/// `docs/02-Domain/05-Mysteries.md`'s Resolution Rules: "Confirming
/// Merchant" and "Selecting Category" resolve a Mystery by correcting
/// the linked Transaction — reuses the same Use Case Finances' edit
/// sheet already calls, so both paths stay consistent.
class ResolveMysteryUseCase extends UseCase<Mystery, ResolveMysteryParams> {
  const ResolveMysteryUseCase(this._repository, this._updateTransactionMerchantCategory);

  final MysteryRepository _repository;
  final UpdateTransactionMerchantCategoryUseCase _updateTransactionMerchantCategory;

  @override
  Future<Result<Mystery>> call(ResolveMysteryParams params) async {
    final updateResult = await _updateTransactionMerchantCategory(
      UpdateTransactionMerchantCategoryParams(
        id: params.transactionId,
        merchant: params.merchant,
        category: params.category,
      ),
    );
    if (updateResult case ResultError(:final failure)) {
      return ResultError(failure);
    }

    if (params.notes != null) {
      final notesResult = await _repository.updateNotes(params.mysteryId, params.notes);
      if (notesResult case ResultError(:final failure)) {
        return ResultError(failure);
      }
    }

    return _repository.updateStatus(params.mysteryId, MysteryStatus.resolved);
  }
}
