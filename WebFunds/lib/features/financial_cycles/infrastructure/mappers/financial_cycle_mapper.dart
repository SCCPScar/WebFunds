import '../../../../services/database/app_database.dart';
import '../../../../shared/models/money.dart';
import '../../domain/entities/financial_cycle.dart';
import '../../domain/entities/financial_cycle_status.dart';

/// The single place in WebFunds that knows both the Drift schema and the
/// Domain entity for Financial Cycles.
class FinancialCycleMapper {
  const FinancialCycleMapper._();

  static FinancialCycle toDomain(FinancialCycleRow row) {
    return FinancialCycle(
      id: row.id,
      name: row.name,
      startDate: row.startDate,
      endDate: row.endDate,
      status: FinancialCycleStatus.values.byName(row.status),
      openingBalance: Money.fromMinorUnits(
        row.openingBalanceMinorUnits,
        currency: row.openingBalanceCurrency,
      ),
      closingBalance: row.closingBalanceMinorUnits == null
          ? null
          : Money.fromMinorUnits(
              row.closingBalanceMinorUnits!,
              currency: row.closingBalanceCurrency!,
            ),
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static FinancialCycleRow toRow(FinancialCycle cycle) {
    return FinancialCycleRow(
      id: cycle.id,
      name: cycle.name,
      startDate: cycle.startDate,
      endDate: cycle.endDate,
      status: cycle.status.name,
      openingBalanceMinorUnits: cycle.openingBalance.minorUnits,
      openingBalanceCurrency: cycle.openingBalance.currency,
      closingBalanceMinorUnits: cycle.closingBalance?.minorUnits,
      closingBalanceCurrency: cycle.closingBalance?.currency,
      createdAt: cycle.createdAt,
      updatedAt: cycle.updatedAt,
    );
  }
}
