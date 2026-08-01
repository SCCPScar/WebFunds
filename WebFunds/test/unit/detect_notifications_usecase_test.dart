import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/utils/clock.dart';
import 'package:webfunds/core/utils/id_generator.dart';
import 'package:webfunds/features/dreams/infrastructure/repositories/drift_dream_repository.dart';
import 'package:webfunds/features/mysteries/domain/entities/mystery_reason.dart';
import 'package:webfunds/features/mysteries/infrastructure/repositories/drift_mystery_repository.dart';
import 'package:webfunds/features/notifications/application/usecases/detect_notifications_usecase.dart';
import 'package:webfunds/features/notifications/domain/entities/notification_category.dart';
import 'package:webfunds/features/notifications/infrastructure/repositories/drift_notification_repository.dart';
import 'package:webfunds/services/database/app_database.dart';
import 'package:webfunds/shared/models/money.dart';

class _SequentialIdGenerator implements IdGenerator {
  int _counter = 0;
  @override
  String generate() => 'notif-test-id-${_counter++}';
}

class _FixedClock implements Clock {
  _FixedClock(this._fixed);
  DateTime _fixed;
  @override
  DateTime now() => _fixed;
}

void main() {
  late AppDatabase database;
  late DriftDreamRepository dreamRepository;
  late DriftMysteryRepository mysteryRepository;
  late DriftNotificationRepository notificationRepository;
  late _FixedClock clock;
  late DetectNotificationsUseCase useCase;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    clock = _FixedClock(DateTime(2026, 1, 1));
    dreamRepository = DriftDreamRepository(database.dreamDao, _SequentialIdGenerator(), clock);
    mysteryRepository =
        DriftMysteryRepository(database.mysteryDao, _SequentialIdGenerator(), clock);
    notificationRepository =
        DriftNotificationRepository(database.notificationDao, _SequentialIdGenerator(), clock);
    useCase = DetectNotificationsUseCase(
        dreamRepository, mysteryRepository, notificationRepository, clock);
  });

  tearDown(() => database.close());

  test('notifies when a Dream reaches 50% of its target', () async {
    final dream =
        await dreamRepository.create(name: 'Viagem', targetAmount: Money.fromMajorUnits(1000));
    await dreamRepository.addContribution(
      dreamId: dream.dataOrNull!.id,
      amount: Money.fromMajorUnits(500),
    );

    final result = await useCase();

    expect(result.dataOrNull!.length, 1);
    expect(result.dataOrNull!.first.category, NotificationCategory.dream);
    expect(result.dataOrNull!.first.sourceKey, 'dream:milestone50:${dream.dataOrNull!.id}');
  });

  test('notifies when a Dream completes, not the 50% milestone', () async {
    final dream =
        await dreamRepository.create(name: 'Viagem', targetAmount: Money.fromMajorUnits(1000));
    await dreamRepository.addContribution(
      dreamId: dream.dataOrNull!.id,
      amount: Money.fromMajorUnits(1000),
    );

    final result = await useCase();

    expect(result.dataOrNull!.length, 1);
    expect(result.dataOrNull!.first.sourceKey, 'dream:completed:${dream.dataOrNull!.id}');
  });

  test('does not notify a Dream below 50%', () async {
    final dream =
        await dreamRepository.create(name: 'Viagem', targetAmount: Money.fromMajorUnits(1000));
    await dreamRepository.addContribution(
      dreamId: dream.dataOrNull!.id,
      amount: Money.fromMajorUnits(200),
    );

    final result = await useCase();

    expect(result.dataOrNull, isEmpty);
  });

  test('notifies once for a newly-detected open Mystery', () async {
    final mystery = await mysteryRepository.create(
        transactionId: 'tx-1', reason: MysteryReason.unknownMerchant);

    final result = await useCase();

    expect(result.dataOrNull!.length, 1);
    expect(result.dataOrNull!.first.sourceKey, 'mystery:detected:${mystery.dataOrNull!.id}');
  });

  test('notifies about a stale Mystery once it has been open for 7+ days', () async {
    await mysteryRepository.create(transactionId: 'tx-1', reason: MysteryReason.unknownMerchant);
    await useCase(); // consumes the "detected" notification

    clock._fixed = DateTime(2026, 1, 9);
    final result = await useCase();

    expect(result.dataOrNull!.length, 1);
    expect(result.dataOrNull!.first.category, NotificationCategory.mystery);
    expect(result.dataOrNull!.first.title, contains('7 dias'));
  });

  test('running detection twice does not create duplicate notifications', () async {
    final dream =
        await dreamRepository.create(name: 'Viagem', targetAmount: Money.fromMajorUnits(1000));
    await dreamRepository.addContribution(
      dreamId: dream.dataOrNull!.id,
      amount: Money.fromMajorUnits(1000),
    );

    await useCase();
    final second = await useCase();

    expect(second.dataOrNull, isEmpty);
  });
}
