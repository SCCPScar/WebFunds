import '../../../../services/database/app_database.dart';
import '../../../../shared/models/money.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_type.dart';

/// The single place in WebFunds that knows both the Drift schema and the
/// Domain entity for Transactions.
class TransactionMapper {
  const TransactionMapper._();

  static Transaction toDomain(TransactionRow row) {
    return Transaction(
      id: row.id,
      financialCycleId: row.financialCycleId,
      accountId: row.accountId,
      type: TransactionType.values.byName(row.type),
      amount: Money.fromMinorUnits(row.amountMinorUnits, currency: row.amountCurrency),
      transactionDate: row.transactionDate,
      merchant: row.merchant,
      category: row.category,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static TransactionRow toRow(Transaction transaction) {
    return TransactionRow(
      id: transaction.id,
      financialCycleId: transaction.financialCycleId,
      accountId: transaction.accountId,
      type: transaction.type.name,
      amountMinorUnits: transaction.amount.minorUnits,
      amountCurrency: transaction.amount.currency,
      transactionDate: transaction.transactionDate,
      merchant: transaction.merchant,
      category: transaction.category,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
    );
  }
}
