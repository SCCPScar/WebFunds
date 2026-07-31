// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts
    with TableInfo<$AccountsTable, AccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _openingBalanceMinorUnitsMeta =
      const VerificationMeta('openingBalanceMinorUnits');
  @override
  late final GeneratedColumn<int> openingBalanceMinorUnits =
      GeneratedColumn<int>('opening_balance_minor_units', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _openingBalanceCurrencyMeta =
      const VerificationMeta('openingBalanceCurrency');
  @override
  late final GeneratedColumn<String> openingBalanceCurrency =
      GeneratedColumn<String>('opening_balance_currency', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('€'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        type,
        openingBalanceMinorUnits,
        openingBalanceCurrency,
        createdAt,
        isArchived
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(Insertable<AccountRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('opening_balance_minor_units')) {
      context.handle(
          _openingBalanceMinorUnitsMeta,
          openingBalanceMinorUnits.isAcceptableOrUnknown(
              data['opening_balance_minor_units']!,
              _openingBalanceMinorUnitsMeta));
    } else if (isInserting) {
      context.missing(_openingBalanceMinorUnitsMeta);
    }
    if (data.containsKey('opening_balance_currency')) {
      context.handle(
          _openingBalanceCurrencyMeta,
          openingBalanceCurrency.isAcceptableOrUnknown(
              data['opening_balance_currency']!, _openingBalanceCurrencyMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      openingBalanceMinorUnits: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}opening_balance_minor_units'])!,
      openingBalanceCurrency: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}opening_balance_currency'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class AccountRow extends DataClass implements Insertable<AccountRow> {
  final String id;
  final String name;

  /// Stores `AccountType.name` as plain text (e.g. "checking"). No Drift
  /// enum column is used here — that would require a Drift-only enum
  /// duplicating `AccountType`, which `AccountMapper` must not depend on.
  final String type;

  /// Money, always as minor units — never REAL/double.
  final int openingBalanceMinorUnits;
  final String openingBalanceCurrency;
  final DateTime createdAt;
  final bool isArchived;
  const AccountRow(
      {required this.id,
      required this.name,
      required this.type,
      required this.openingBalanceMinorUnits,
      required this.openingBalanceCurrency,
      required this.createdAt,
      required this.isArchived});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['opening_balance_minor_units'] =
        Variable<int>(openingBalanceMinorUnits);
    map['opening_balance_currency'] = Variable<String>(openingBalanceCurrency);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      openingBalanceMinorUnits: Value(openingBalanceMinorUnits),
      openingBalanceCurrency: Value(openingBalanceCurrency),
      createdAt: Value(createdAt),
      isArchived: Value(isArchived),
    );
  }

  factory AccountRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      openingBalanceMinorUnits:
          serializer.fromJson<int>(json['openingBalanceMinorUnits']),
      openingBalanceCurrency:
          serializer.fromJson<String>(json['openingBalanceCurrency']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'openingBalanceMinorUnits':
          serializer.toJson<int>(openingBalanceMinorUnits),
      'openingBalanceCurrency':
          serializer.toJson<String>(openingBalanceCurrency),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  AccountRow copyWith(
          {String? id,
          String? name,
          String? type,
          int? openingBalanceMinorUnits,
          String? openingBalanceCurrency,
          DateTime? createdAt,
          bool? isArchived}) =>
      AccountRow(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        openingBalanceMinorUnits:
            openingBalanceMinorUnits ?? this.openingBalanceMinorUnits,
        openingBalanceCurrency:
            openingBalanceCurrency ?? this.openingBalanceCurrency,
        createdAt: createdAt ?? this.createdAt,
        isArchived: isArchived ?? this.isArchived,
      );
  AccountRow copyWithCompanion(AccountsCompanion data) {
    return AccountRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      openingBalanceMinorUnits: data.openingBalanceMinorUnits.present
          ? data.openingBalanceMinorUnits.value
          : this.openingBalanceMinorUnits,
      openingBalanceCurrency: data.openingBalanceCurrency.present
          ? data.openingBalanceCurrency.value
          : this.openingBalanceCurrency,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('openingBalanceMinorUnits: $openingBalanceMinorUnits, ')
          ..write('openingBalanceCurrency: $openingBalanceCurrency, ')
          ..write('createdAt: $createdAt, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, openingBalanceMinorUnits,
      openingBalanceCurrency, createdAt, isArchived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.openingBalanceMinorUnits == this.openingBalanceMinorUnits &&
          other.openingBalanceCurrency == this.openingBalanceCurrency &&
          other.createdAt == this.createdAt &&
          other.isArchived == this.isArchived);
}

class AccountsCompanion extends UpdateCompanion<AccountRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<int> openingBalanceMinorUnits;
  final Value<String> openingBalanceCurrency;
  final Value<DateTime> createdAt;
  final Value<bool> isArchived;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.openingBalanceMinorUnits = const Value.absent(),
    this.openingBalanceCurrency = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required String name,
    required String type,
    required int openingBalanceMinorUnits,
    this.openingBalanceCurrency = const Value.absent(),
    required DateTime createdAt,
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        type = Value(type),
        openingBalanceMinorUnits = Value(openingBalanceMinorUnits),
        createdAt = Value(createdAt);
  static Insertable<AccountRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? openingBalanceMinorUnits,
    Expression<String>? openingBalanceCurrency,
    Expression<DateTime>? createdAt,
    Expression<bool>? isArchived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (openingBalanceMinorUnits != null)
        'opening_balance_minor_units': openingBalanceMinorUnits,
      if (openingBalanceCurrency != null)
        'opening_balance_currency': openingBalanceCurrency,
      if (createdAt != null) 'created_at': createdAt,
      if (isArchived != null) 'is_archived': isArchived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? type,
      Value<int>? openingBalanceMinorUnits,
      Value<String>? openingBalanceCurrency,
      Value<DateTime>? createdAt,
      Value<bool>? isArchived,
      Value<int>? rowid}) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      openingBalanceMinorUnits:
          openingBalanceMinorUnits ?? this.openingBalanceMinorUnits,
      openingBalanceCurrency:
          openingBalanceCurrency ?? this.openingBalanceCurrency,
      createdAt: createdAt ?? this.createdAt,
      isArchived: isArchived ?? this.isArchived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (openingBalanceMinorUnits.present) {
      map['opening_balance_minor_units'] =
          Variable<int>(openingBalanceMinorUnits.value);
    }
    if (openingBalanceCurrency.present) {
      map['opening_balance_currency'] =
          Variable<String>(openingBalanceCurrency.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('openingBalanceMinorUnits: $openingBalanceMinorUnits, ')
          ..write('openingBalanceCurrency: $openingBalanceCurrency, ')
          ..write('createdAt: $createdAt, ')
          ..write('isArchived: $isArchived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FinancialCyclesTable extends FinancialCycles
    with TableInfo<$FinancialCyclesTable, FinancialCycleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinancialCyclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _openingBalanceMinorUnitsMeta =
      const VerificationMeta('openingBalanceMinorUnits');
  @override
  late final GeneratedColumn<int> openingBalanceMinorUnits =
      GeneratedColumn<int>('opening_balance_minor_units', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _openingBalanceCurrencyMeta =
      const VerificationMeta('openingBalanceCurrency');
  @override
  late final GeneratedColumn<String> openingBalanceCurrency =
      GeneratedColumn<String>('opening_balance_currency', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('€'));
  static const VerificationMeta _closingBalanceMinorUnitsMeta =
      const VerificationMeta('closingBalanceMinorUnits');
  @override
  late final GeneratedColumn<int> closingBalanceMinorUnits =
      GeneratedColumn<int>('closing_balance_minor_units', aliasedName, true,
          type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _closingBalanceCurrencyMeta =
      const VerificationMeta('closingBalanceCurrency');
  @override
  late final GeneratedColumn<String> closingBalanceCurrency =
      GeneratedColumn<String>('closing_balance_currency', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        startDate,
        endDate,
        status,
        openingBalanceMinorUnits,
        openingBalanceCurrency,
        closingBalanceMinorUnits,
        closingBalanceCurrency,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'financial_cycles';
  @override
  VerificationContext validateIntegrity(Insertable<FinancialCycleRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('opening_balance_minor_units')) {
      context.handle(
          _openingBalanceMinorUnitsMeta,
          openingBalanceMinorUnits.isAcceptableOrUnknown(
              data['opening_balance_minor_units']!,
              _openingBalanceMinorUnitsMeta));
    } else if (isInserting) {
      context.missing(_openingBalanceMinorUnitsMeta);
    }
    if (data.containsKey('opening_balance_currency')) {
      context.handle(
          _openingBalanceCurrencyMeta,
          openingBalanceCurrency.isAcceptableOrUnknown(
              data['opening_balance_currency']!, _openingBalanceCurrencyMeta));
    }
    if (data.containsKey('closing_balance_minor_units')) {
      context.handle(
          _closingBalanceMinorUnitsMeta,
          closingBalanceMinorUnits.isAcceptableOrUnknown(
              data['closing_balance_minor_units']!,
              _closingBalanceMinorUnitsMeta));
    }
    if (data.containsKey('closing_balance_currency')) {
      context.handle(
          _closingBalanceCurrencyMeta,
          closingBalanceCurrency.isAcceptableOrUnknown(
              data['closing_balance_currency']!, _closingBalanceCurrencyMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinancialCycleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinancialCycleRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      openingBalanceMinorUnits: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}opening_balance_minor_units'])!,
      openingBalanceCurrency: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}opening_balance_currency'])!,
      closingBalanceMinorUnits: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}closing_balance_minor_units']),
      closingBalanceCurrency: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}closing_balance_currency']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $FinancialCyclesTable createAlias(String alias) {
    return $FinancialCyclesTable(attachedDatabase, alias);
  }
}

class FinancialCycleRow extends DataClass
    implements Insertable<FinancialCycleRow> {
  final String id;
  final String? name;
  final DateTime startDate;
  final DateTime? endDate;

  /// Stores `FinancialCycleStatus.name` as plain text (e.g. "active").
  /// No Drift-only enum column — that would duplicate the Domain enum.
  final String status;

  /// Money, always as minor units — never REAL/double.
  final int openingBalanceMinorUnits;
  final String openingBalanceCurrency;
  final int? closingBalanceMinorUnits;
  final String? closingBalanceCurrency;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FinancialCycleRow(
      {required this.id,
      this.name,
      required this.startDate,
      this.endDate,
      required this.status,
      required this.openingBalanceMinorUnits,
      required this.openingBalanceCurrency,
      this.closingBalanceMinorUnits,
      this.closingBalanceCurrency,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['status'] = Variable<String>(status);
    map['opening_balance_minor_units'] =
        Variable<int>(openingBalanceMinorUnits);
    map['opening_balance_currency'] = Variable<String>(openingBalanceCurrency);
    if (!nullToAbsent || closingBalanceMinorUnits != null) {
      map['closing_balance_minor_units'] =
          Variable<int>(closingBalanceMinorUnits);
    }
    if (!nullToAbsent || closingBalanceCurrency != null) {
      map['closing_balance_currency'] =
          Variable<String>(closingBalanceCurrency);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FinancialCyclesCompanion toCompanion(bool nullToAbsent) {
    return FinancialCyclesCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      status: Value(status),
      openingBalanceMinorUnits: Value(openingBalanceMinorUnits),
      openingBalanceCurrency: Value(openingBalanceCurrency),
      closingBalanceMinorUnits: closingBalanceMinorUnits == null && nullToAbsent
          ? const Value.absent()
          : Value(closingBalanceMinorUnits),
      closingBalanceCurrency: closingBalanceCurrency == null && nullToAbsent
          ? const Value.absent()
          : Value(closingBalanceCurrency),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FinancialCycleRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinancialCycleRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      status: serializer.fromJson<String>(json['status']),
      openingBalanceMinorUnits:
          serializer.fromJson<int>(json['openingBalanceMinorUnits']),
      openingBalanceCurrency:
          serializer.fromJson<String>(json['openingBalanceCurrency']),
      closingBalanceMinorUnits:
          serializer.fromJson<int?>(json['closingBalanceMinorUnits']),
      closingBalanceCurrency:
          serializer.fromJson<String?>(json['closingBalanceCurrency']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'status': serializer.toJson<String>(status),
      'openingBalanceMinorUnits':
          serializer.toJson<int>(openingBalanceMinorUnits),
      'openingBalanceCurrency':
          serializer.toJson<String>(openingBalanceCurrency),
      'closingBalanceMinorUnits':
          serializer.toJson<int?>(closingBalanceMinorUnits),
      'closingBalanceCurrency':
          serializer.toJson<String?>(closingBalanceCurrency),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FinancialCycleRow copyWith(
          {String? id,
          Value<String?> name = const Value.absent(),
          DateTime? startDate,
          Value<DateTime?> endDate = const Value.absent(),
          String? status,
          int? openingBalanceMinorUnits,
          String? openingBalanceCurrency,
          Value<int?> closingBalanceMinorUnits = const Value.absent(),
          Value<String?> closingBalanceCurrency = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      FinancialCycleRow(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        startDate: startDate ?? this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        status: status ?? this.status,
        openingBalanceMinorUnits:
            openingBalanceMinorUnits ?? this.openingBalanceMinorUnits,
        openingBalanceCurrency:
            openingBalanceCurrency ?? this.openingBalanceCurrency,
        closingBalanceMinorUnits: closingBalanceMinorUnits.present
            ? closingBalanceMinorUnits.value
            : this.closingBalanceMinorUnits,
        closingBalanceCurrency: closingBalanceCurrency.present
            ? closingBalanceCurrency.value
            : this.closingBalanceCurrency,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  FinancialCycleRow copyWithCompanion(FinancialCyclesCompanion data) {
    return FinancialCycleRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      status: data.status.present ? data.status.value : this.status,
      openingBalanceMinorUnits: data.openingBalanceMinorUnits.present
          ? data.openingBalanceMinorUnits.value
          : this.openingBalanceMinorUnits,
      openingBalanceCurrency: data.openingBalanceCurrency.present
          ? data.openingBalanceCurrency.value
          : this.openingBalanceCurrency,
      closingBalanceMinorUnits: data.closingBalanceMinorUnits.present
          ? data.closingBalanceMinorUnits.value
          : this.closingBalanceMinorUnits,
      closingBalanceCurrency: data.closingBalanceCurrency.present
          ? data.closingBalanceCurrency.value
          : this.closingBalanceCurrency,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinancialCycleRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('openingBalanceMinorUnits: $openingBalanceMinorUnits, ')
          ..write('openingBalanceCurrency: $openingBalanceCurrency, ')
          ..write('closingBalanceMinorUnits: $closingBalanceMinorUnits, ')
          ..write('closingBalanceCurrency: $closingBalanceCurrency, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      startDate,
      endDate,
      status,
      openingBalanceMinorUnits,
      openingBalanceCurrency,
      closingBalanceMinorUnits,
      closingBalanceCurrency,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinancialCycleRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.status == this.status &&
          other.openingBalanceMinorUnits == this.openingBalanceMinorUnits &&
          other.openingBalanceCurrency == this.openingBalanceCurrency &&
          other.closingBalanceMinorUnits == this.closingBalanceMinorUnits &&
          other.closingBalanceCurrency == this.closingBalanceCurrency &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FinancialCyclesCompanion extends UpdateCompanion<FinancialCycleRow> {
  final Value<String> id;
  final Value<String?> name;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<String> status;
  final Value<int> openingBalanceMinorUnits;
  final Value<String> openingBalanceCurrency;
  final Value<int?> closingBalanceMinorUnits;
  final Value<String?> closingBalanceCurrency;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FinancialCyclesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.status = const Value.absent(),
    this.openingBalanceMinorUnits = const Value.absent(),
    this.openingBalanceCurrency = const Value.absent(),
    this.closingBalanceMinorUnits = const Value.absent(),
    this.closingBalanceCurrency = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FinancialCyclesCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    required DateTime startDate,
    this.endDate = const Value.absent(),
    required String status,
    required int openingBalanceMinorUnits,
    this.openingBalanceCurrency = const Value.absent(),
    this.closingBalanceMinorUnits = const Value.absent(),
    this.closingBalanceCurrency = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        startDate = Value(startDate),
        status = Value(status),
        openingBalanceMinorUnits = Value(openingBalanceMinorUnits),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<FinancialCycleRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? status,
    Expression<int>? openingBalanceMinorUnits,
    Expression<String>? openingBalanceCurrency,
    Expression<int>? closingBalanceMinorUnits,
    Expression<String>? closingBalanceCurrency,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (status != null) 'status': status,
      if (openingBalanceMinorUnits != null)
        'opening_balance_minor_units': openingBalanceMinorUnits,
      if (openingBalanceCurrency != null)
        'opening_balance_currency': openingBalanceCurrency,
      if (closingBalanceMinorUnits != null)
        'closing_balance_minor_units': closingBalanceMinorUnits,
      if (closingBalanceCurrency != null)
        'closing_balance_currency': closingBalanceCurrency,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FinancialCyclesCompanion copyWith(
      {Value<String>? id,
      Value<String?>? name,
      Value<DateTime>? startDate,
      Value<DateTime?>? endDate,
      Value<String>? status,
      Value<int>? openingBalanceMinorUnits,
      Value<String>? openingBalanceCurrency,
      Value<int?>? closingBalanceMinorUnits,
      Value<String?>? closingBalanceCurrency,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return FinancialCyclesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      openingBalanceMinorUnits:
          openingBalanceMinorUnits ?? this.openingBalanceMinorUnits,
      openingBalanceCurrency:
          openingBalanceCurrency ?? this.openingBalanceCurrency,
      closingBalanceMinorUnits:
          closingBalanceMinorUnits ?? this.closingBalanceMinorUnits,
      closingBalanceCurrency:
          closingBalanceCurrency ?? this.closingBalanceCurrency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (openingBalanceMinorUnits.present) {
      map['opening_balance_minor_units'] =
          Variable<int>(openingBalanceMinorUnits.value);
    }
    if (openingBalanceCurrency.present) {
      map['opening_balance_currency'] =
          Variable<String>(openingBalanceCurrency.value);
    }
    if (closingBalanceMinorUnits.present) {
      map['closing_balance_minor_units'] =
          Variable<int>(closingBalanceMinorUnits.value);
    }
    if (closingBalanceCurrency.present) {
      map['closing_balance_currency'] =
          Variable<String>(closingBalanceCurrency.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinancialCyclesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('openingBalanceMinorUnits: $openingBalanceMinorUnits, ')
          ..write('openingBalanceCurrency: $openingBalanceCurrency, ')
          ..write('closingBalanceMinorUnits: $closingBalanceMinorUnits, ')
          ..write('closingBalanceCurrency: $closingBalanceCurrency, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, TransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _financialCycleIdMeta =
      const VerificationMeta('financialCycleId');
  @override
  late final GeneratedColumn<String> financialCycleId = GeneratedColumn<String>(
      'financial_cycle_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMinorUnitsMeta =
      const VerificationMeta('amountMinorUnits');
  @override
  late final GeneratedColumn<int> amountMinorUnits = GeneratedColumn<int>(
      'amount_minor_units', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _amountCurrencyMeta =
      const VerificationMeta('amountCurrency');
  @override
  late final GeneratedColumn<String> amountCurrency = GeneratedColumn<String>(
      'amount_currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('€'));
  static const VerificationMeta _transactionDateMeta =
      const VerificationMeta('transactionDate');
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>('transaction_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _merchantMeta =
      const VerificationMeta('merchant');
  @override
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
      'merchant', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        financialCycleId,
        accountId,
        type,
        amountMinorUnits,
        amountCurrency,
        transactionDate,
        merchant,
        category,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<TransactionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('financial_cycle_id')) {
      context.handle(
          _financialCycleIdMeta,
          financialCycleId.isAcceptableOrUnknown(
              data['financial_cycle_id']!, _financialCycleIdMeta));
    } else if (isInserting) {
      context.missing(_financialCycleIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount_minor_units')) {
      context.handle(
          _amountMinorUnitsMeta,
          amountMinorUnits.isAcceptableOrUnknown(
              data['amount_minor_units']!, _amountMinorUnitsMeta));
    } else if (isInserting) {
      context.missing(_amountMinorUnitsMeta);
    }
    if (data.containsKey('amount_currency')) {
      context.handle(
          _amountCurrencyMeta,
          amountCurrency.isAcceptableOrUnknown(
              data['amount_currency']!, _amountCurrencyMeta));
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
          _transactionDateMeta,
          transactionDate.isAcceptableOrUnknown(
              data['transaction_date']!, _transactionDateMeta));
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('merchant')) {
      context.handle(_merchantMeta,
          merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      financialCycleId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}financial_cycle_id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      amountMinorUnits: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}amount_minor_units'])!,
      amountCurrency: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}amount_currency'])!,
      transactionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}transaction_date'])!,
      merchant: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}merchant']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class TransactionRow extends DataClass implements Insertable<TransactionRow> {
  final String id;
  final String financialCycleId;
  final String accountId;

  /// Stores `TransactionType.name` as plain text (e.g. "expense"). No
  /// Drift-only enum column — that would duplicate the Domain enum.
  final String type;

  /// Money, always as minor units, always positive — never REAL/double.
  final int amountMinorUnits;
  final String amountCurrency;
  final DateTime transactionDate;
  final String? merchant;
  final String? category;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TransactionRow(
      {required this.id,
      required this.financialCycleId,
      required this.accountId,
      required this.type,
      required this.amountMinorUnits,
      required this.amountCurrency,
      required this.transactionDate,
      this.merchant,
      this.category,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['financial_cycle_id'] = Variable<String>(financialCycleId);
    map['account_id'] = Variable<String>(accountId);
    map['type'] = Variable<String>(type);
    map['amount_minor_units'] = Variable<int>(amountMinorUnits);
    map['amount_currency'] = Variable<String>(amountCurrency);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    if (!nullToAbsent || merchant != null) {
      map['merchant'] = Variable<String>(merchant);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      financialCycleId: Value(financialCycleId),
      accountId: Value(accountId),
      type: Value(type),
      amountMinorUnits: Value(amountMinorUnits),
      amountCurrency: Value(amountCurrency),
      transactionDate: Value(transactionDate),
      merchant: merchant == null && nullToAbsent
          ? const Value.absent()
          : Value(merchant),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TransactionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionRow(
      id: serializer.fromJson<String>(json['id']),
      financialCycleId: serializer.fromJson<String>(json['financialCycleId']),
      accountId: serializer.fromJson<String>(json['accountId']),
      type: serializer.fromJson<String>(json['type']),
      amountMinorUnits: serializer.fromJson<int>(json['amountMinorUnits']),
      amountCurrency: serializer.fromJson<String>(json['amountCurrency']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      merchant: serializer.fromJson<String?>(json['merchant']),
      category: serializer.fromJson<String?>(json['category']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'financialCycleId': serializer.toJson<String>(financialCycleId),
      'accountId': serializer.toJson<String>(accountId),
      'type': serializer.toJson<String>(type),
      'amountMinorUnits': serializer.toJson<int>(amountMinorUnits),
      'amountCurrency': serializer.toJson<String>(amountCurrency),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'merchant': serializer.toJson<String?>(merchant),
      'category': serializer.toJson<String?>(category),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TransactionRow copyWith(
          {String? id,
          String? financialCycleId,
          String? accountId,
          String? type,
          int? amountMinorUnits,
          String? amountCurrency,
          DateTime? transactionDate,
          Value<String?> merchant = const Value.absent(),
          Value<String?> category = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      TransactionRow(
        id: id ?? this.id,
        financialCycleId: financialCycleId ?? this.financialCycleId,
        accountId: accountId ?? this.accountId,
        type: type ?? this.type,
        amountMinorUnits: amountMinorUnits ?? this.amountMinorUnits,
        amountCurrency: amountCurrency ?? this.amountCurrency,
        transactionDate: transactionDate ?? this.transactionDate,
        merchant: merchant.present ? merchant.value : this.merchant,
        category: category.present ? category.value : this.category,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  TransactionRow copyWithCompanion(TransactionsCompanion data) {
    return TransactionRow(
      id: data.id.present ? data.id.value : this.id,
      financialCycleId: data.financialCycleId.present
          ? data.financialCycleId.value
          : this.financialCycleId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      type: data.type.present ? data.type.value : this.type,
      amountMinorUnits: data.amountMinorUnits.present
          ? data.amountMinorUnits.value
          : this.amountMinorUnits,
      amountCurrency: data.amountCurrency.present
          ? data.amountCurrency.value
          : this.amountCurrency,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      category: data.category.present ? data.category.value : this.category,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionRow(')
          ..write('id: $id, ')
          ..write('financialCycleId: $financialCycleId, ')
          ..write('accountId: $accountId, ')
          ..write('type: $type, ')
          ..write('amountMinorUnits: $amountMinorUnits, ')
          ..write('amountCurrency: $amountCurrency, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('merchant: $merchant, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      financialCycleId,
      accountId,
      type,
      amountMinorUnits,
      amountCurrency,
      transactionDate,
      merchant,
      category,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionRow &&
          other.id == this.id &&
          other.financialCycleId == this.financialCycleId &&
          other.accountId == this.accountId &&
          other.type == this.type &&
          other.amountMinorUnits == this.amountMinorUnits &&
          other.amountCurrency == this.amountCurrency &&
          other.transactionDate == this.transactionDate &&
          other.merchant == this.merchant &&
          other.category == this.category &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsCompanion extends UpdateCompanion<TransactionRow> {
  final Value<String> id;
  final Value<String> financialCycleId;
  final Value<String> accountId;
  final Value<String> type;
  final Value<int> amountMinorUnits;
  final Value<String> amountCurrency;
  final Value<DateTime> transactionDate;
  final Value<String?> merchant;
  final Value<String?> category;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.financialCycleId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.type = const Value.absent(),
    this.amountMinorUnits = const Value.absent(),
    this.amountCurrency = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.merchant = const Value.absent(),
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required String financialCycleId,
    required String accountId,
    required String type,
    required int amountMinorUnits,
    this.amountCurrency = const Value.absent(),
    required DateTime transactionDate,
    this.merchant = const Value.absent(),
    this.category = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        financialCycleId = Value(financialCycleId),
        accountId = Value(accountId),
        type = Value(type),
        amountMinorUnits = Value(amountMinorUnits),
        transactionDate = Value(transactionDate),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<TransactionRow> custom({
    Expression<String>? id,
    Expression<String>? financialCycleId,
    Expression<String>? accountId,
    Expression<String>? type,
    Expression<int>? amountMinorUnits,
    Expression<String>? amountCurrency,
    Expression<DateTime>? transactionDate,
    Expression<String>? merchant,
    Expression<String>? category,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (financialCycleId != null) 'financial_cycle_id': financialCycleId,
      if (accountId != null) 'account_id': accountId,
      if (type != null) 'type': type,
      if (amountMinorUnits != null) 'amount_minor_units': amountMinorUnits,
      if (amountCurrency != null) 'amount_currency': amountCurrency,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (merchant != null) 'merchant': merchant,
      if (category != null) 'category': category,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? financialCycleId,
      Value<String>? accountId,
      Value<String>? type,
      Value<int>? amountMinorUnits,
      Value<String>? amountCurrency,
      Value<DateTime>? transactionDate,
      Value<String?>? merchant,
      Value<String?>? category,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      financialCycleId: financialCycleId ?? this.financialCycleId,
      accountId: accountId ?? this.accountId,
      type: type ?? this.type,
      amountMinorUnits: amountMinorUnits ?? this.amountMinorUnits,
      amountCurrency: amountCurrency ?? this.amountCurrency,
      transactionDate: transactionDate ?? this.transactionDate,
      merchant: merchant ?? this.merchant,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (financialCycleId.present) {
      map['financial_cycle_id'] = Variable<String>(financialCycleId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amountMinorUnits.present) {
      map['amount_minor_units'] = Variable<int>(amountMinorUnits.value);
    }
    if (amountCurrency.present) {
      map['amount_currency'] = Variable<String>(amountCurrency.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('financialCycleId: $financialCycleId, ')
          ..write('accountId: $accountId, ')
          ..write('type: $type, ')
          ..write('amountMinorUnits: $amountMinorUnits, ')
          ..write('amountCurrency: $amountCurrency, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('merchant: $merchant, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $FinancialCyclesTable financialCycles =
      $FinancialCyclesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final AccountDao accountDao = AccountDao(this as AppDatabase);
  late final FinancialCycleDao financialCycleDao =
      FinancialCycleDao(this as AppDatabase);
  late final TransactionDao transactionDao =
      TransactionDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [accounts, financialCycles, transactions];
}

typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  required String id,
  required String name,
  required String type,
  required int openingBalanceMinorUnits,
  Value<String> openingBalanceCurrency,
  required DateTime createdAt,
  Value<bool> isArchived,
  Value<int> rowid,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> type,
  Value<int> openingBalanceMinorUnits,
  Value<String> openingBalanceCurrency,
  Value<DateTime> createdAt,
  Value<bool> isArchived,
  Value<int> rowid,
});

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get openingBalanceMinorUnits => $composableBuilder(
      column: $table.openingBalanceMinorUnits,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get openingBalanceCurrency => $composableBuilder(
      column: $table.openingBalanceCurrency,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get openingBalanceMinorUnits => $composableBuilder(
      column: $table.openingBalanceMinorUnits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get openingBalanceCurrency => $composableBuilder(
      column: $table.openingBalanceCurrency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get openingBalanceMinorUnits => $composableBuilder(
      column: $table.openingBalanceMinorUnits, builder: (column) => column);

  GeneratedColumn<String> get openingBalanceCurrency => $composableBuilder(
      column: $table.openingBalanceCurrency, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);
}

class $$AccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountsTable,
    AccountRow,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (AccountRow, BaseReferences<_$AppDatabase, $AccountsTable, AccountRow>),
    AccountRow,
    PrefetchHooks Function()> {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> openingBalanceMinorUnits = const Value.absent(),
            Value<String> openingBalanceCurrency = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsCompanion(
            id: id,
            name: name,
            type: type,
            openingBalanceMinorUnits: openingBalanceMinorUnits,
            openingBalanceCurrency: openingBalanceCurrency,
            createdAt: createdAt,
            isArchived: isArchived,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String type,
            required int openingBalanceMinorUnits,
            Value<String> openingBalanceCurrency = const Value.absent(),
            required DateTime createdAt,
            Value<bool> isArchived = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsCompanion.insert(
            id: id,
            name: name,
            type: type,
            openingBalanceMinorUnits: openingBalanceMinorUnits,
            openingBalanceCurrency: openingBalanceCurrency,
            createdAt: createdAt,
            isArchived: isArchived,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccountsTable,
    AccountRow,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (AccountRow, BaseReferences<_$AppDatabase, $AccountsTable, AccountRow>),
    AccountRow,
    PrefetchHooks Function()>;
typedef $$FinancialCyclesTableCreateCompanionBuilder = FinancialCyclesCompanion
    Function({
  required String id,
  Value<String?> name,
  required DateTime startDate,
  Value<DateTime?> endDate,
  required String status,
  required int openingBalanceMinorUnits,
  Value<String> openingBalanceCurrency,
  Value<int?> closingBalanceMinorUnits,
  Value<String?> closingBalanceCurrency,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$FinancialCyclesTableUpdateCompanionBuilder = FinancialCyclesCompanion
    Function({
  Value<String> id,
  Value<String?> name,
  Value<DateTime> startDate,
  Value<DateTime?> endDate,
  Value<String> status,
  Value<int> openingBalanceMinorUnits,
  Value<String> openingBalanceCurrency,
  Value<int?> closingBalanceMinorUnits,
  Value<String?> closingBalanceCurrency,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$FinancialCyclesTableFilterComposer
    extends Composer<_$AppDatabase, $FinancialCyclesTable> {
  $$FinancialCyclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get openingBalanceMinorUnits => $composableBuilder(
      column: $table.openingBalanceMinorUnits,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get openingBalanceCurrency => $composableBuilder(
      column: $table.openingBalanceCurrency,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get closingBalanceMinorUnits => $composableBuilder(
      column: $table.closingBalanceMinorUnits,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get closingBalanceCurrency => $composableBuilder(
      column: $table.closingBalanceCurrency,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$FinancialCyclesTableOrderingComposer
    extends Composer<_$AppDatabase, $FinancialCyclesTable> {
  $$FinancialCyclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get openingBalanceMinorUnits => $composableBuilder(
      column: $table.openingBalanceMinorUnits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get openingBalanceCurrency => $composableBuilder(
      column: $table.openingBalanceCurrency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get closingBalanceMinorUnits => $composableBuilder(
      column: $table.closingBalanceMinorUnits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get closingBalanceCurrency => $composableBuilder(
      column: $table.closingBalanceCurrency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$FinancialCyclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinancialCyclesTable> {
  $$FinancialCyclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get openingBalanceMinorUnits => $composableBuilder(
      column: $table.openingBalanceMinorUnits, builder: (column) => column);

  GeneratedColumn<String> get openingBalanceCurrency => $composableBuilder(
      column: $table.openingBalanceCurrency, builder: (column) => column);

  GeneratedColumn<int> get closingBalanceMinorUnits => $composableBuilder(
      column: $table.closingBalanceMinorUnits, builder: (column) => column);

  GeneratedColumn<String> get closingBalanceCurrency => $composableBuilder(
      column: $table.closingBalanceCurrency, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FinancialCyclesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FinancialCyclesTable,
    FinancialCycleRow,
    $$FinancialCyclesTableFilterComposer,
    $$FinancialCyclesTableOrderingComposer,
    $$FinancialCyclesTableAnnotationComposer,
    $$FinancialCyclesTableCreateCompanionBuilder,
    $$FinancialCyclesTableUpdateCompanionBuilder,
    (
      FinancialCycleRow,
      BaseReferences<_$AppDatabase, $FinancialCyclesTable, FinancialCycleRow>
    ),
    FinancialCycleRow,
    PrefetchHooks Function()> {
  $$FinancialCyclesTableTableManager(
      _$AppDatabase db, $FinancialCyclesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinancialCyclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinancialCyclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinancialCyclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> openingBalanceMinorUnits = const Value.absent(),
            Value<String> openingBalanceCurrency = const Value.absent(),
            Value<int?> closingBalanceMinorUnits = const Value.absent(),
            Value<String?> closingBalanceCurrency = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FinancialCyclesCompanion(
            id: id,
            name: name,
            startDate: startDate,
            endDate: endDate,
            status: status,
            openingBalanceMinorUnits: openingBalanceMinorUnits,
            openingBalanceCurrency: openingBalanceCurrency,
            closingBalanceMinorUnits: closingBalanceMinorUnits,
            closingBalanceCurrency: closingBalanceCurrency,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> name = const Value.absent(),
            required DateTime startDate,
            Value<DateTime?> endDate = const Value.absent(),
            required String status,
            required int openingBalanceMinorUnits,
            Value<String> openingBalanceCurrency = const Value.absent(),
            Value<int?> closingBalanceMinorUnits = const Value.absent(),
            Value<String?> closingBalanceCurrency = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              FinancialCyclesCompanion.insert(
            id: id,
            name: name,
            startDate: startDate,
            endDate: endDate,
            status: status,
            openingBalanceMinorUnits: openingBalanceMinorUnits,
            openingBalanceCurrency: openingBalanceCurrency,
            closingBalanceMinorUnits: closingBalanceMinorUnits,
            closingBalanceCurrency: closingBalanceCurrency,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FinancialCyclesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FinancialCyclesTable,
    FinancialCycleRow,
    $$FinancialCyclesTableFilterComposer,
    $$FinancialCyclesTableOrderingComposer,
    $$FinancialCyclesTableAnnotationComposer,
    $$FinancialCyclesTableCreateCompanionBuilder,
    $$FinancialCyclesTableUpdateCompanionBuilder,
    (
      FinancialCycleRow,
      BaseReferences<_$AppDatabase, $FinancialCyclesTable, FinancialCycleRow>
    ),
    FinancialCycleRow,
    PrefetchHooks Function()>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  required String id,
  required String financialCycleId,
  required String accountId,
  required String type,
  required int amountMinorUnits,
  Value<String> amountCurrency,
  required DateTime transactionDate,
  Value<String?> merchant,
  Value<String?> category,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<String> id,
  Value<String> financialCycleId,
  Value<String> accountId,
  Value<String> type,
  Value<int> amountMinorUnits,
  Value<String> amountCurrency,
  Value<DateTime> transactionDate,
  Value<String?> merchant,
  Value<String?> category,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get financialCycleId => $composableBuilder(
      column: $table.financialCycleId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountMinorUnits => $composableBuilder(
      column: $table.amountMinorUnits,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get amountCurrency => $composableBuilder(
      column: $table.amountCurrency,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get merchant => $composableBuilder(
      column: $table.merchant, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get financialCycleId => $composableBuilder(
      column: $table.financialCycleId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountMinorUnits => $composableBuilder(
      column: $table.amountMinorUnits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get amountCurrency => $composableBuilder(
      column: $table.amountCurrency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get merchant => $composableBuilder(
      column: $table.merchant, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get financialCycleId => $composableBuilder(
      column: $table.financialCycleId, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amountMinorUnits => $composableBuilder(
      column: $table.amountMinorUnits, builder: (column) => column);

  GeneratedColumn<String> get amountCurrency => $composableBuilder(
      column: $table.amountCurrency, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate, builder: (column) => column);

  GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    TransactionRow,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      TransactionRow,
      BaseReferences<_$AppDatabase, $TransactionsTable, TransactionRow>
    ),
    TransactionRow,
    PrefetchHooks Function()> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> financialCycleId = const Value.absent(),
            Value<String> accountId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> amountMinorUnits = const Value.absent(),
            Value<String> amountCurrency = const Value.absent(),
            Value<DateTime> transactionDate = const Value.absent(),
            Value<String?> merchant = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            financialCycleId: financialCycleId,
            accountId: accountId,
            type: type,
            amountMinorUnits: amountMinorUnits,
            amountCurrency: amountCurrency,
            transactionDate: transactionDate,
            merchant: merchant,
            category: category,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String financialCycleId,
            required String accountId,
            required String type,
            required int amountMinorUnits,
            Value<String> amountCurrency = const Value.absent(),
            required DateTime transactionDate,
            Value<String?> merchant = const Value.absent(),
            Value<String?> category = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            financialCycleId: financialCycleId,
            accountId: accountId,
            type: type,
            amountMinorUnits: amountMinorUnits,
            amountCurrency: amountCurrency,
            transactionDate: transactionDate,
            merchant: merchant,
            category: category,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    TransactionRow,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      TransactionRow,
      BaseReferences<_$AppDatabase, $TransactionsTable, TransactionRow>
    ),
    TransactionRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$FinancialCyclesTableTableManager get financialCycles =>
      $$FinancialCyclesTableTableManager(_db, _db.financialCycles);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
}
