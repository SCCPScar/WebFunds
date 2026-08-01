// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mystery_dao.dart';

// ignore_for_file: type=lint
mixin _$MysteryDaoMixin on DatabaseAccessor<AppDatabase> {
  $MysteriesTable get mysteries => attachedDatabase.mysteries;
  MysteryDaoManager get managers => MysteryDaoManager(this);
}

class MysteryDaoManager {
  final _$MysteryDaoMixin _db;
  MysteryDaoManager(this._db);
  $$MysteriesTableTableManager get mysteries =>
      $$MysteriesTableTableManager(_db.attachedDatabase, _db.mysteries);
}
