// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_cycle_dao.dart';

// ignore_for_file: type=lint
mixin _$FinancialCycleDaoMixin on DatabaseAccessor<AppDatabase> {
  $FinancialCyclesTable get financialCycles => attachedDatabase.financialCycles;
  FinancialCycleDaoManager get managers => FinancialCycleDaoManager(this);
}

class FinancialCycleDaoManager {
  final _$FinancialCycleDaoMixin _db;
  FinancialCycleDaoManager(this._db);
  $$FinancialCyclesTableTableManager get financialCycles =>
      $$FinancialCyclesTableTableManager(
          _db.attachedDatabase, _db.financialCycles);
}
