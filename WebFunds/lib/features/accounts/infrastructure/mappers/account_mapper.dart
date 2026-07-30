import '../../../../services/database/tables/accounts_table.dart';
import '../../../../shared/models/money.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/account_type.dart';

/// The single place in WebFunds that knows both the Drift schema and the
/// Domain entity. Depends only on `AccountType` (Domain) — no Drift-side
/// enum exists to duplicate it.
class AccountMapper {
  const AccountMapper._();

  static Account toDomain(AccountRow row) {
    return Account(
      id: row.id,
      name: row.name,
      type: AccountType.values.byName(row.type),
      openingBalance: Money.fromMinorUnits(
        row.openingBalanceMinorUnits,
        currency: row.openingBalanceCurrency,
      ),
      createdAt: row.createdAt,
      isArchived: row.isArchived,
    );
  }

  static AccountRow toRow(Account account) {
    return AccountRow(
      id: account.id,
      name: account.name,
      type: account.type.name,
      openingBalanceMinorUnits: account.openingBalance.minorUnits,
      openingBalanceCurrency: account.openingBalance.currency,
      createdAt: account.createdAt,
      isArchived: account.isArchived,
    );
  }
}