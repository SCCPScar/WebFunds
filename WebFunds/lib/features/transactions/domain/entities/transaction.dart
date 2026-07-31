import '../../../../shared/models/money.dart';
import 'transaction_type.dart';

/// A Transaction — one recorded financial movement. Manual-entry core
/// only: `docs/02-Domain/02-Transactions.md` also defines Story, Receipt,
/// Memory, location, tags and AI analysis, all deferred until Weaver/OCR
/// exist to make them meaningful.
class Transaction {
  const Transaction({
    required this.id,
    required this.financialCycleId,
    required this.accountId,
    required this.type,
    required this.amount,
    required this.transactionDate,
    this.merchant,
    this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String financialCycleId;
  final String accountId;
  final TransactionType type;

  /// Always positive — direction comes from [type], never the sign of
  /// this value (`docs/02-Domain/02-Transactions.md`, "Amount Rules").
  final Money amount;

  final DateTime transactionDate;
  final String? merchant;
  final String? category;
  final DateTime createdAt;
  final DateTime updatedAt;
}
