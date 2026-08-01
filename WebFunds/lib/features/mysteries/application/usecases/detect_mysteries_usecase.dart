import '../../../../core/result/result.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/entities/transaction_type.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../domain/entities/mystery.dart';
import '../../domain/entities/mystery_reason.dart';
import '../../domain/repositories/mystery_repository.dart';

/// Scans Transactions for the rule-detectable "Creation Rules" from
/// `docs/02-Domain/05-Mysteries.md` (Unknown Merchant, Unknown Category)
/// and persists a Mystery for each newly-found one. Unlike Subscription
/// suggestions, detection itself creates the Mystery — the doc treats
/// "Detected" as a real, persisted lifecycle stage; only *resolving* it
/// is the confirmed owner action that matters.
class DetectMysteriesUseCase {
  const DetectMysteriesUseCase(this._transactionRepository, this._mysteryRepository);

  final TransactionRepository _transactionRepository;
  final MysteryRepository _mysteryRepository;

  Future<Result<List<Mystery>>> call() async {
    final transactionsResult = await _transactionRepository.getAll();
    if (transactionsResult case ResultError(:final failure)) {
      return ResultError(failure);
    }
    final transactions = transactionsResult.dataOrNull ?? const <Transaction>[];

    final existingResult = await _mysteryRepository.getAll();
    final transactionsWithMystery = {
      for (final m in existingResult.dataOrNull ?? const <Mystery>[]) m.transactionId,
    };

    final created = <Mystery>[];
    for (final t in transactions) {
      if (t.type != TransactionType.expense) continue;
      if (transactionsWithMystery.contains(t.id)) continue;

      final reason = _reasonFor(t);
      if (reason == null) continue;

      final result = await _mysteryRepository.create(transactionId: t.id, reason: reason);
      if (result case Success(:final data)) {
        created.add(data);
      }
    }

    return Success(created);
  }

  MysteryReason? _reasonFor(Transaction transaction) {
    final merchant = transaction.merchant?.trim();
    if (merchant == null || merchant.isEmpty) return MysteryReason.unknownMerchant;

    final category = transaction.category?.trim();
    if (category == null || category.isEmpty) return MysteryReason.unknownCategory;

    return null;
  }
}
