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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final AccountDao accountDao = AccountDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [accounts];
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
}
