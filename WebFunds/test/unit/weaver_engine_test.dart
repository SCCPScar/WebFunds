import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/features/accounts/domain/entities/account.dart';
import 'package:webfunds/features/accounts/domain/entities/account_type.dart';
import 'package:webfunds/features/transactions/domain/entities/transaction.dart';
import 'package:webfunds/features/transactions/domain/entities/transaction_type.dart';
import 'package:webfunds/features/weaver/application/engine/weaver_engine.dart';
import 'package:webfunds/features/weaver/domain/entities/weaver_alert.dart';
import 'package:webfunds/features/weaver/domain/entities/weaver_insight.dart';
import 'package:webfunds/features/weaver/domain/entities/weaver_recommendation.dart';
import 'package:webfunds/shared/models/money.dart';

void main() {
  const engine = WeaverEngine();

  Account account(String id, String name, AccountType type, double opening) {
    return Account(
      id: id,
      name: name,
      type: type,
      openingBalance: Money.fromMajorUnits(opening),
      createdAt: DateTime(2026, 1, 1),
    );
  }

  Transaction transaction(String accountId, TransactionType type, double amount) {
    return Transaction(
      id: 'tx-$accountId-${type.name}',
      financialCycleId: 'cycle-1',
      accountId: accountId,
      type: type,
      amount: Money.fromMajorUnits(amount),
      transactionDate: DateTime(2026, 1, 5),
      createdAt: DateTime(2026, 1, 5),
      updatedAt: DateTime(2026, 1, 5),
    );
  }

  group('generateInsights', () {
    test('returns nothing when there are no Accounts', () {
      final insights =
          engine.generateInsights(accounts: const [], balances: const {}, transactions: const []);

      expect(insights, isEmpty);
    });

    test('computes total net worth as the sum of every balance', () {
      final accounts = [
        account('a1', 'Conta à ordem', AccountType.checking, 100),
        account('a2', 'Poupança', AccountType.savings, 400),
      ];
      final balances = {
        'a1': Money.fromMajorUnits(100),
        'a2': Money.fromMajorUnits(400),
      };

      final insights = engine.generateInsights(
        accounts: accounts,
        balances: balances,
        transactions: const [],
      );

      final netWorth = insights.firstWhere((i) => i.type == WeaverInsightType.totalNetWorth);
      expect(netWorth.description, Money.fromMajorUnits(500).format());
    });

    test('identifies the largest and lowest-balance Accounts', () {
      final accounts = [
        account('a1', 'Conta à ordem', AccountType.checking, 100),
        account('a2', 'Poupança', AccountType.savings, 400),
      ];
      final balances = {
        'a1': Money.fromMajorUnits(100),
        'a2': Money.fromMajorUnits(400),
      };

      final insights = engine.generateInsights(
        accounts: accounts,
        balances: balances,
        transactions: const [],
      );

      final largest = insights.firstWhere((i) => i.type == WeaverInsightType.largestAccount);
      final lowest = insights.firstWhere((i) => i.type == WeaverInsightType.lowestBalance);
      expect(largest.description, contains('Poupança'));
      expect(lowest.description, contains('Conta à ordem'));
    });

    test('flags an Account with no Transactions as dormant', () {
      final accounts = [
        account('a1', 'Conta à ordem', AccountType.checking, 100),
        account('a2', 'Poupança', AccountType.savings, 400),
      ];
      final balances = {
        'a1': Money.fromMajorUnits(100),
        'a2': Money.fromMajorUnits(400),
      };
      final transactions = [transaction('a1', TransactionType.expense, 20)];

      final insights = engine.generateInsights(
        accounts: accounts,
        balances: balances,
        transactions: transactions,
      );

      final dormant = insights.firstWhere((i) => i.type == WeaverInsightType.dormantAccounts);
      expect(dormant.description, contains('Poupança'));
      expect(dormant.description, isNot(contains('Conta à ordem')));
    });

    test('omits the dormant-Accounts insight when every Account has activity', () {
      final accounts = [account('a1', 'Conta à ordem', AccountType.checking, 100)];
      final balances = {'a1': Money.fromMajorUnits(100)};
      final transactions = [transaction('a1', TransactionType.expense, 20)];

      final insights = engine.generateInsights(
        accounts: accounts,
        balances: balances,
        transactions: transactions,
      );

      expect(insights.where((i) => i.type == WeaverInsightType.dormantAccounts), isEmpty);
    });
  });

  group('generateRecommendations', () {
    test('recommends registering Transactions when there are none yet', () {
      final accounts = [account('a1', 'Conta à ordem', AccountType.checking, 100)];
      final balances = {'a1': Money.fromMajorUnits(100)};

      final recommendations = engine.generateRecommendations(
        accounts: accounts,
        balances: balances,
        transactions: const [],
      );

      expect(
        recommendations.map((r) => r.type),
        contains(WeaverRecommendationType.noTransactionsYet),
      );
    });

    test('recommends diversifying when there is only one Account', () {
      final accounts = [account('a1', 'Conta à ordem', AccountType.checking, 100)];
      final balances = {'a1': Money.fromMajorUnits(100)};
      final transactions = [transaction('a1', TransactionType.expense, 20)];

      final recommendations = engine.generateRecommendations(
        accounts: accounts,
        balances: balances,
        transactions: transactions,
      );

      expect(
        recommendations.map((r) => r.type),
        contains(WeaverRecommendationType.singleAccountConcentration),
      );
    });

    test('does not recommend diversifying when there are multiple Accounts', () {
      final accounts = [
        account('a1', 'Conta à ordem', AccountType.checking, 100),
        account('a2', 'Poupança', AccountType.savings, 400),
      ];
      final balances = {
        'a1': Money.fromMajorUnits(100),
        'a2': Money.fromMajorUnits(400),
      };
      final transactions = [
        transaction('a1', TransactionType.expense, 20),
        transaction('a2', TransactionType.expense, 20),
      ];

      final recommendations = engine.generateRecommendations(
        accounts: accounts,
        balances: balances,
        transactions: transactions,
      );

      expect(
        recommendations.map((r) => r.type),
        isNot(contains(WeaverRecommendationType.singleAccountConcentration)),
      );
    });
  });

  group('generateAlerts', () {
    test('alerts on a negative balance', () {
      final accounts = [account('a1', 'Conta à ordem', AccountType.checking, -50)];
      final balances = {'a1': Money.fromMajorUnits(-50)};

      final alerts = engine.generateAlerts(
        accounts: accounts,
        balances: balances,
        transactions: const [],
      );

      expect(alerts, hasLength(1));
      expect(alerts.first.severity, WeaverAlertSeverity.warning);
    });

    test('does not alert when every balance is non-negative', () {
      final accounts = [account('a1', 'Conta à ordem', AccountType.checking, 50)];
      final balances = {'a1': Money.fromMajorUnits(50)};

      final alerts = engine.generateAlerts(
        accounts: accounts,
        balances: balances,
        transactions: const [],
      );

      expect(alerts, isEmpty);
    });
  });
}
