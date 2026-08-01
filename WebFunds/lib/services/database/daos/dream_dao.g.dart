// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dream_dao.dart';

// ignore_for_file: type=lint
mixin _$DreamDaoMixin on DatabaseAccessor<AppDatabase> {
  $DreamsTable get dreams => attachedDatabase.dreams;
  $DreamMovementsTable get dreamMovements => attachedDatabase.dreamMovements;
  DreamDaoManager get managers => DreamDaoManager(this);
}

class DreamDaoManager {
  final _$DreamDaoMixin _db;
  DreamDaoManager(this._db);
  $$DreamsTableTableManager get dreams =>
      $$DreamsTableTableManager(_db.attachedDatabase, _db.dreams);
  $$DreamMovementsTableTableManager get dreamMovements =>
      $$DreamMovementsTableTableManager(
          _db.attachedDatabase, _db.dreamMovements);
}
