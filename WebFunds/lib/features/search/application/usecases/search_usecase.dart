import '../../../../core/result/result.dart';
import '../../../dreams/domain/entities/dream.dart';
import '../../../dreams/domain/repositories/dream_repository.dart';
import '../../../mysteries/domain/entities/mystery.dart';
import '../../../mysteries/domain/repositories/mystery_repository.dart';
import '../../../subscriptions/domain/entities/subscription.dart';
import '../../../subscriptions/domain/repositories/subscription_repository.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/entities/search_result_type.dart';

class SearchParams {
  const SearchParams(this.query);
  final String query;
}

/// Client-side global search — `docs/01-Experience/09-Search.md`. No
/// search index exists (or is needed at this app's scale): every call
/// re-scans the 4 repositories' one-shot `getAll()`/`getActive()`
/// methods and filters in memory. Natural-language interpretation
/// ("Weaver Search" in the doc) is out of scope — this only does plain
/// case-insensitive substring matching against each entity's own
/// user-facing text fields.
class SearchUseCase {
  const SearchUseCase(
    this._transactionRepository,
    this._dreamRepository,
    this._mysteryRepository,
    this._subscriptionRepository,
  );

  final TransactionRepository _transactionRepository;
  final DreamRepository _dreamRepository;
  final MysteryRepository _mysteryRepository;
  final SubscriptionRepository _subscriptionRepository;

  Future<Result<List<SearchResult>>> call(SearchParams params) async {
    final query = params.query.trim().toLowerCase();
    if (query.isEmpty) return const Success([]);

    final results = <SearchResult>[];

    final transactionsResult = await _transactionRepository.getAll();
    for (final t in transactionsResult.dataOrNull ?? const <Transaction>[]) {
      if (!_matchesTransaction(t, query)) continue;
      results.add(
        SearchResult(
          type: SearchResultType.transaction,
          entityId: t.id,
          title: t.merchant ?? 'Transação sem merchant',
          subtitle: '${t.amount.format()} · ${t.category ?? 'Sem categoria'}',
          sortDate: t.transactionDate,
        ),
      );
    }

    final dreamsResult = await _dreamRepository.getActive();
    for (final d in dreamsResult.dataOrNull ?? const <Dream>[]) {
      if (!_contains(d.name, query) && !_contains(d.category, query)) continue;
      results.add(
        SearchResult(
          type: SearchResultType.dream,
          entityId: d.id,
          title: d.name,
          subtitle: '${(d.progress * 100).round()}% · ${d.reservedAmount.format()}',
          sortDate: d.updatedAt,
        ),
      );
    }

    final mysteriesResult = await _mysteryRepository.getAll();
    for (final m in mysteriesResult.dataOrNull ?? const <Mystery>[]) {
      if (!_contains(m.notes, query) && !_contains(m.reason.name, query)) continue;
      results.add(
        SearchResult(
          type: SearchResultType.mystery,
          entityId: m.transactionId,
          title: m.notes?.isNotEmpty == true ? m.notes! : m.reason.name,
          subtitle: m.status.name,
          sortDate: m.createdAt,
        ),
      );
    }

    final subscriptionsResult = await _subscriptionRepository.getAll();
    for (final s in subscriptionsResult.dataOrNull ?? const <Subscription>[]) {
      if (!_contains(s.merchant, query) && !_contains(s.category, query)) continue;
      results.add(
        SearchResult(
          type: SearchResultType.subscription,
          entityId: s.id,
          title: s.merchant,
          subtitle: '${s.expectedAmount.format()} · ${s.frequency.name}',
          sortDate: s.updatedAt,
        ),
      );
    }

    results.sort((a, b) => b.sortDate.compareTo(a.sortDate));
    return Success(results);
  }

  bool _matchesTransaction(Transaction t, String query) {
    return _contains(t.merchant, query) || _contains(t.category, query);
  }

  bool _contains(String? field, String query) {
    return field != null && field.toLowerCase().contains(query);
  }
}
