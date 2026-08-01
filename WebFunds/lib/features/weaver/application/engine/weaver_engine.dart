import '../../../../shared/models/money.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/domain/entities/account_type.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../domain/entities/weaver_alert.dart';
import '../../domain/entities/weaver_insight.dart';
import '../../domain/entities/weaver_recommendation.dart';

/// Weaver's local financial-intelligence core — "a financial copilot
/// that interprets the owner's data", not a chat. Pure, synchronous,
/// UI-independent: no HTTP, no OpenAI/Claude/Gemini, nothing async.
/// Every method here is a plain aggregation over Accounts/Transactions;
/// wiring a real LLM later (via `AIRepository`) augments this, it never
/// replaces it — these rules stay meaningful with or without AI.
class WeaverEngine {
  const WeaverEngine();

  /// `accounts` and `balances` are handed in already computed —
  /// `WeaverEngine` never talks to a Repository, that's each
  /// `GenerateXUseCase`'s job.
  List<WeaverInsight> generateInsights({
    required List<Account> accounts,
    required Map<String, Money> balances,
    required List<Transaction> transactions,
  }) {
    if (accounts.isEmpty) return const [];

    final currency = accounts.first.openingBalance.currency;
    final totalNetWorth = balances.values.fold(
      Money.zero(currency: currency),
      (sum, balance) => sum + balance,
    );

    final byBalance = [...accounts]..sort((a, b) => balances[a.id]!.compareTo(balances[b.id]!));
    final lowest = byBalance.first;
    final largest = byBalance.last;

    final dormant =
        accounts.where((account) => transactions.every((t) => t.accountId != account.id)).toList();

    final distribution = <AccountType, int>{};
    for (final account in accounts) {
      distribution[account.type] = (distribution[account.type] ?? 0) + 1;
    }

    return [
      WeaverInsight(
        type: WeaverInsightType.totalNetWorth,
        title: 'Património total',
        description: totalNetWorth.format(),
      ),
      WeaverInsight(
        type: WeaverInsightType.largestAccount,
        title: 'Maior conta',
        description: '${largest.name} · ${balances[largest.id]!.format()}',
      ),
      WeaverInsight(
        type: WeaverInsightType.lowestBalance,
        title: 'Conta com menor saldo',
        description: '${lowest.name} · ${balances[lowest.id]!.format()}',
      ),
      WeaverInsight(
        type: WeaverInsightType.accountCount,
        title: 'Número de contas',
        description: '${accounts.length} ${accounts.length == 1 ? 'conta' : 'contas'}',
      ),
      if (dormant.isNotEmpty)
        WeaverInsight(
          type: WeaverInsightType.dormantAccounts,
          title: 'Contas sem movimentação',
          description: dormant.map((a) => a.name).join(', '),
        ),
      WeaverInsight(
        type: WeaverInsightType.typeDistribution,
        title: 'Distribuição por tipo',
        description: distribution.entries.map((e) => '${e.value} × ${e.key.name}').join(' · '),
      ),
    ];
  }

  List<WeaverRecommendation> generateRecommendations({
    required List<Account> accounts,
    required Map<String, Money> balances,
    required List<Transaction> transactions,
  }) {
    if (accounts.isEmpty) return const [];

    final recommendations = <WeaverRecommendation>[];

    if (transactions.isEmpty) {
      recommendations.add(
        const WeaverRecommendation(
          type: WeaverRecommendationType.noTransactionsYet,
          title: 'Começa a registar',
          description:
              'Ainda não tens transações registadas. Regista algumas para o Weaver começar a '
              'gerar recomendações mais precisas.',
        ),
      );
    }

    final dormant =
        accounts.where((account) => transactions.every((t) => t.accountId != account.id)).toList();
    if (dormant.isNotEmpty) {
      recommendations.add(
        WeaverRecommendation(
          type: WeaverRecommendationType.dormantAccounts,
          title: 'Contas sem uso',
          description: '${dormant.map((a) => a.name).join(', ')} '
              '${dormant.length == 1 ? 'não tem' : 'não têm'} transações. Considera arquivar '
              'ou voltar a usar.',
        ),
      );
    }

    if (accounts.length == 1) {
      recommendations.add(
        const WeaverRecommendation(
          type: WeaverRecommendationType.singleAccountConcentration,
          title: 'Uma só conta',
          description:
              'Todo o teu património está numa única conta. Considera adicionar outra para '
              'uma visão mais completa das tuas finanças.',
        ),
      );
    }

    return recommendations;
  }

  List<WeaverAlert> generateAlerts({
    required List<Account> accounts,
    required Map<String, Money> balances,
    required List<Transaction> transactions,
  }) {
    final negative = accounts.where((a) => balances[a.id]?.isNegative ?? false);

    return [
      for (final account in negative)
        WeaverAlert(
          severity: WeaverAlertSeverity.warning,
          title: 'Saldo negativo',
          description:
              '${account.name} está com saldo negativo (${balances[account.id]!.format()}).',
        ),
    ];
  }
}
