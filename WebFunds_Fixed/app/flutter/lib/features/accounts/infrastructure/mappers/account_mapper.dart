import '../../../../services/database/tables/accounts_table.dart';
import '../../../../shared/models/money.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/account_type.dart';

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
