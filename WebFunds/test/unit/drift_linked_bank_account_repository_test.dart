import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/utils/clock.dart';
import 'package:webfunds/features/weaver/domain/repositories/bank_repository.dart';
import 'package:webfunds/features/weaver/infrastructure/repositories/drift_linked_bank_account_repository.dart';
import 'package:webfunds/services/database/app_database.dart';

class _FixedClock implements Clock {
  _FixedClock(this._fixed);
  final DateTime _fixed;
  @override
  DateTime now() => _fixed;
}

void main() {
  late AppDatabase database;
  late DriftLinkedBankAccountRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftLinkedBankAccountRepository(
      database.linkedBankAccountDao,
      _FixedClock(DateTime(2026, 1, 1)),
    );
  });

  tearDown(() => database.close());

  test('watchAll starts empty', () async {
    final result = await repository.watchAll().first;
    expect(result.dataOrNull, isEmpty);
  });

  test('saveAll persists Accounts, watchAll reflects them', () async {
    const account = BankAccount(
      id: 'acc-1',
      institutionName: 'Millennium BCP',
      iban: 'PT50...',
      displayName: 'Conta à ordem',
    );

    final saveResult = await repository.saveAll([account]);
    expect(saveResult.isSuccess, isTrue);

    final all = await repository.watchAll().first;
    expect(all.dataOrNull!.single.id, 'acc-1');
    expect(all.dataOrNull!.single.displayName, 'Conta à ordem');
  });

  test('saveAll upserts rather than duplicating an existing id', () async {
    const original = BankAccount(
      id: 'acc-1',
      institutionName: 'Millennium BCP',
      iban: 'PT50...',
      displayName: 'Conta à ordem',
    );
    const renamed = BankAccount(
      id: 'acc-1',
      institutionName: 'Millennium BCP',
      iban: 'PT50...',
      displayName: 'Conta principal',
    );

    await repository.saveAll([original]);
    await repository.saveAll([renamed]);

    final all = await repository.watchAll().first;
    expect(all.dataOrNull!.length, 1);
    expect(all.dataOrNull!.single.displayName, 'Conta principal');
  });

  test('unlink removes the Account', () async {
    const account = BankAccount(
      id: 'acc-1',
      institutionName: 'Millennium BCP',
      iban: 'PT50...',
      displayName: 'Conta à ordem',
    );
    await repository.saveAll([account]);

    final unlinkResult = await repository.unlink('acc-1');
    expect(unlinkResult.isSuccess, isTrue);

    final all = await repository.watchAll().first;
    expect(all.dataOrNull, isEmpty);
  });
}
