import '../../../../core/result/result.dart';
import '../../../../shared/models/money.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/entities/transaction_type.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/subscription_frequency.dart';
import '../../domain/entities/subscription_suggestion.dart';
import '../../domain/repositories/subscription_repository.dart';

/// Rule-based recurring-payment detector — `docs/02-Domain/08-Subscriptions.md`'s
/// "Detection Rules" (Recurring Merchant, Recurring Amount, Recurring
/// Interval), without the AI-driven "Merchant Similarity"/historical-
/// pattern learning Weaver eventually adds. Never persists anything —
/// every suggestion is recomputed fresh, and only exists until the owner
/// confirms or ignores it.
class DetectSubscriptionSuggestionsUseCase {
  const DetectSubscriptionSuggestionsUseCase(
    this._transactionRepository,
    this._subscriptionRepository,
  );

  final TransactionRepository _transactionRepository;
  final SubscriptionRepository _subscriptionRepository;

  static const _minOccurrences = 2;
  static const _amountToleranceRatio = 0.15;
  static const _frequencyToleranceRatio = 0.25;

  static const _frequencyBuckets = {
    SubscriptionFrequency.weekly: 7,
    SubscriptionFrequency.biweekly: 14,
    SubscriptionFrequency.monthly: 30,
    SubscriptionFrequency.quarterly: 91,
    SubscriptionFrequency.semiannual: 182,
    SubscriptionFrequency.annual: 365,
  };

  Future<Result<List<SubscriptionSuggestion>>> call() async {
    final transactionsResult = await _transactionRepository.getAll();
    if (transactionsResult case ResultError(:final failure)) {
      return ResultError(failure);
    }
    final transactions = transactionsResult.dataOrNull ?? const <Transaction>[];

    final existingResult = await _subscriptionRepository.getAll();
    final existingMerchants = {
      for (final s in existingResult.dataOrNull ?? const <Subscription>[]) s.merchant,
    };

    final byMerchant = <String, List<Transaction>>{};
    for (final t in transactions) {
      if (t.type != TransactionType.expense) continue;
      final merchant = t.merchant?.trim();
      if (merchant == null || merchant.isEmpty) continue;
      if (existingMerchants.contains(merchant)) continue;
      (byMerchant[merchant] ??= []).add(t);
    }

    final suggestions = <SubscriptionSuggestion>[];
    for (final entry in byMerchant.entries) {
      final suggestion = _detect(entry.key, entry.value);
      if (suggestion != null) suggestions.add(suggestion);
    }

    suggestions.sort((a, b) => b.confidenceScore.compareTo(a.confidenceScore));
    return Success(suggestions);
  }

  SubscriptionSuggestion? _detect(String merchant, List<Transaction> transactions) {
    if (transactions.length < _minOccurrences) return null;

    final sorted = [...transactions]..sort(
        (a, b) => a.transactionDate.compareTo(b.transactionDate),
      );

    final avgAmount =
        sorted.fold<int>(0, (sum, t) => sum + t.amount.minorUnits) / sorted.length;
    final amountsConsistent = sorted.every(
      (t) => (t.amount.minorUnits - avgAmount).abs() <= avgAmount * _amountToleranceRatio,
    );
    if (!amountsConsistent) return null;

    final gaps = <int>[
      for (var i = 1; i < sorted.length; i++)
        sorted[i].transactionDate.difference(sorted[i - 1].transactionDate).inDays,
    ];
    final avgGap = gaps.fold<int>(0, (sum, g) => sum + g) / gaps.length;

    final frequency = _classifyFrequency(avgGap);
    if (frequency == null) return null;

    final maxDeviation = gaps.map((g) => (g - avgGap).abs()).reduce((a, b) => a > b ? a : b);
    final regularity = avgGap == 0 ? 0.0 : 1 - (maxDeviation / avgGap).clamp(0.0, 1.0);
    final occurrenceBonus = (sorted.length - _minOccurrences).clamp(0, 4) * 5;
    final confidence = (40 + regularity * 40 + occurrenceBonus).round().clamp(0, 100);

    return SubscriptionSuggestion(
      merchant: merchant,
      averageAmount: Money.fromMinorUnits(avgAmount.round()),
      frequency: frequency,
      occurrenceCount: sorted.length,
      lastTransactionDate: sorted.last.transactionDate,
      confidenceScore: confidence,
    );
  }

  SubscriptionFrequency? _classifyFrequency(double averageGapDays) {
    for (final entry in _frequencyBuckets.entries) {
      final low = entry.value * (1 - _frequencyToleranceRatio);
      final high = entry.value * (1 + _frequencyToleranceRatio);
      if (averageGapDays >= low && averageGapDays <= high) return entry.key;
    }
    return null;
  }
}
