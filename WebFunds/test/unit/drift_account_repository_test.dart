import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/utils/clock.dart';
import 'package:webfunds/core/utils/id_generator.dart';
import 'package:webfunds/features/accounts/domain/entities/account.dart';
import 'package:webfunds/features/accounts/domain/entities/account_type.dart';
import 'package:webfunds/features/accounts/infrastructure/repositories/drift_account_repository.dart';
import 'package:webfunds/services/database/app_database.dart';
import 'package:webfunds/shared/models/money.dart';

class _SequentialIdGenerator implements IdGenerator {
  int _counter = 0;
  @override
  String generate() => 'test-id-${_counter++}';
}

class _FixedClock implements Clock {
  const _FixedClock(this._fixed);
  final DateTime _fixed;
  @override
  DateTime now() => _fixed;
}

void main() {
  late AppDatabase database;
  late DriftAccountRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftAccountRepository(
      database.accountDao,
      _SequentialIdGenerator(),
      _FixedClock(DateTime(2026, 1, 1)),
    );
  });

  tearDown(() => database.close());

  test('create persists an Account with a generated id and the injected clock', () async {
    final result = await repository.create(
      name: 'Conta Corrente',
      type: AccountType.checking,
      openingBalance: Money.fromMajorUnits(100),
    );

    expect(result.isSuccess, isTrue);
    final account = result.dataOrNull!;
    expect(account.id, 'test-id-0');
    expect(account.createdAt, DateTime(2026, 1, 1));
    expect(account.openingBalance, Money.fromMajorUnits(100));
    expect(account.isArchived, isFalse);
  });

  test('watchAll reacts live: emits empty, then with the account, then without it', () async {
    final stream = repository.watchAll();

    final expectation = expectLater(
      stream,
      emitsInOrder([
        predicate<Result<List<Account>>>((r) => r.dataOrNull!.isEmpty, 'empty list'),
        predicate<Result<List<Account>>>((r) => r.dataOrNull!.length == 1, 'one account'),
        predicate<Result<List<Account>>>((r) => r.dataOrNull!.isEmpty, 'empty again after archive'),
      ]),
    );

    final created = await repository.create(
      name: 'Reativa',
      type: AccountType.checking,
      openingBalance: Money.zero(),
    );
    await repository.archive(created.dataOrNull!.id);

    await expectation;
  });

  test('getById returns null for a non-existent id, never an error', () async {
    final result = await repository.getById('does-not-exist');
    expect(result.isSuccess, isTrue);
    expect(result.dataOrNull, isNull);
  });

  test('update persists changes to name and openingBalance', () async {
    final created = await repository.create(
      name: 'Original',
      type: AccountType.cash,
      openingBalance: Money.zero(),
    );
    final account = created.dataOrNull!;

    await repository.update(
      Account(
        id: account.id,
        name: 'Atualizada',
        type: account.type,
        openingBalance: Money.fromMajorUnits(50),
        createdAt: account.createdAt,
      ),
    );

    final refetched = (await repository.getById(account.id)).dataOrNull!;
    expect(refetched.name, 'Atualizada');
    expect(refetched.openingBalance, Money.fromMajorUnits(50));
  });

  test('money survives a round trip through Drift as minor units, never as double', () async {
    final result = await repository.create(
      name: 'Precisão',
      type: AccountType.checking,
      openingBalance: Money.fromMajorUnits(19.99),
    );
    final refetched = (await repository.getById(result.dataOrNull!.id)).dataOrNull!;

    expect(refetched.openingBalance.minorUnits, 1999);
  });
}
(nota: este ficheiro precisa também de import 'package:webfunds/core/result/result.dart'; para o tipo Result<List<Account>> usado no predicate<...> do teste de reatividade — adiciona-o ao bloco de imports do topo se o analyzer acusar falta.)

### MANIFESTO — todos os ficheiros entregues

lib/main.dart
lib/main_development.dart
lib/main_staging.dart
lib/main_production.dart
lib/app.dart

lib/config/environment.dart
lib/config/env_config.dart
lib/config/bootstrap.dart

lib/core/errors/failure.dart
lib/core/errors/app_exception.dart
lib/core/errors/failure_mapper.dart
lib/core/result/result.dart
lib/core/usecase/use_case.dart
lib/core/usecase/stream_use_case.dart
lib/core/utils/validators.dart
lib/core/utils/id_generator.dart
lib/core/utils/clock.dart
lib/core/extensions/build_context_extensions.dart
lib/core/animation/motion_durations.dart
lib/core/animation/motion_curves.dart
lib/core/animation/motion_tokens.dart
lib/core/animation/page_transitions.dart
lib/core/animation/animations.dart

lib/design_system/colors/app_colors.dart
lib/design_system/typography/app_typography.dart
lib/design_system/spacing/app_spacing.dart
lib/design_system/radius/app_radius.dart
lib/design_system/elevation/app_elevation.dart
lib/design_system/shadows/app_shadows.dart
lib/design_system/opacity/app_opacity.dart
lib/design_system/gradients/app_gradients.dart
lib/design_system/motion/design_motion.dart
lib/design_system/icons/app_icons.dart
lib/design_system/breakpoints/app_breakpoints.dart

lib/theme/app_theme.dart
lib/theme/theme_mode_provider.dart

lib/shared/models/money.dart
lib/shared/widgets/app_loading_indicator.dart
lib/shared/widgets/app_error_view.dart
lib/shared/widgets/app_empty_state.dart
lib/shared/widgets/app_offline_banner.dart
lib/shared/widgets/app_text_field.dart

lib/services/logging/app_logger.dart
lib/services/network/connectivity_service.dart
lib/services/network/dio_client.dart
lib/services/supabase/supabase_service.dart
lib/services/biometric/biometric_service.dart
lib/services/storage/secure_storage_service.dart
lib/services/database/local_database_service.dart
lib/services/database/app_database.dart
lib/services/database/tables/accounts_table.dart
lib/services/database/daos/account_dao.dart

lib/startup/startup_result.dart
lib/startup/startup_task.dart
lib/startup/tasks/session_check_task.dart
lib/startup/tasks/minimum_dwell_task.dart
lib/startup/startup_coordinator.dart
lib/startup/startup_provider.dart

lib/navigation/app_navigation_context.dart
lib/navigation/app_navigation_resolver.dart
lib/navigation/app_navigation_resolver_provider.dart

lib/router/app_routes.dart
lib/router/app_router.dart

lib/shell/app_shell.dart
lib/shell/app_shell_destination.dart

lib/features/auth/domain/entities/auth_user.dart
lib/features/auth/domain/repositories/auth_repository.dart
lib/features/auth/domain/repositories/session_repository.dart
lib/features/auth/domain/repositories/biometric_preference_repository.dart
lib/features/auth/application/usecases/sign_in_with_email_usecase.dart
lib/features/auth/application/usecases/check_session_usecase.dart
lib/features/auth/application/usecases/get_biometric_preference_usecase.dart
lib/features/auth/application/usecases/set_biometric_preference_usecase.dart
lib/features/auth/infrastructure/repositories/auth_repository_impl.dart
lib/features/auth/infrastructure/repositories/supabase_session_repository.dart
lib/features/auth/infrastructure/repositories/secure_storage_biometric_preference_repository.dart
lib/features/auth/presentation/controllers/auth_providers.dart
lib/features/auth/presentation/controllers/login_controller.dart
lib/features/auth/presentation/controllers/auth_gate_controller.dart
lib/features/auth/presentation/widgets/login_form.dart
lib/features/auth/presentation/pages/splash_page.dart
lib/features/auth/presentation/pages/login_page.dart
lib/features/auth/presentation/pages/face_id_page.dart

lib/features/central/domain/entities/dashboard_summary.dart
lib/features/central/domain/repositories/dashboard_repository.dart
lib/features/central/application/usecases/get_dashboard_summary_usecase.dart
lib/features/central/infrastructure/repositories/mock_dashboard_repository.dart
lib/features/central/presentation/controllers/dashboard_providers.dart
lib/features/central/presentation/widgets/summary_section.dart
lib/features/central/presentation/widgets/accounts_section.dart
lib/features/central/presentation/widgets/goals_section.dart
lib/features/central/presentation/widgets/recent_activity_section.dart
lib/features/central/presentation/pages/central_page.dart

lib/features/finances/presentation/pages/finances_page.dart
lib/features/vault/presentation/pages/vault_page.dart
lib/features/mysteries/presentation/pages/mysteries_page.dart
lib/features/weaver/presentation/pages/weaver_page.dart

lib/features/accounts/domain/entities/account_type.dart
lib/features/accounts/domain/entities/account.dart
lib/features/accounts/domain/repositories/account_repository.dart
lib/features/accounts/application/usecases/watch_accounts_usecase.dart
lib/features/accounts/application/usecases/create_account_usecase.dart
lib/features/accounts/application/usecases/archive_account_usecase.dart
lib/features/accounts/infrastructure/mappers/account_mapper.dart
lib/features/accounts/infrastructure/repositories/drift_account_repository.dart
lib/features/accounts/presentation/controllers/account_providers.dart

test/widget/app_smoke_test.dart
test/unit/result_test.dart
test/unit/startup_coordinator_test.dart
test/unit/app_navigation_resolver_test.dart
test/unit/money_test.dart
test/unit/dashboard_repository_test.dart
test/unit/get_dashboard_summary_usecase_test.dart
test/unit/drift_account_repository_test.dart

pubspec.yaml
analysis_options.yaml
.gitignore
env/development.json
env/staging.json
env/production.json
env/README.md
Total: 98 ficheiros.
Não incluídos de propósito (não fazem parte do estado final — foram removidos ao longo das milestones): lib/core/widgets/foundation_placeholder_page.dart (01.1, substituída na 01.3), lib/core/widgets/home_shell_placeholder_page.dart (01.4, substituída na 01.5), lib/features/auth/infrastructure/repositories/fake_session_repository.dart (01.4A, substituída pela SupabaseSessionRepository).
Ainda em falta, por não teres colado/anexado nada nesta conversa (mencionado nas duas últimas mensagens tuas, mas nunca chegou a acontecer): a auditoria pós-integração que combinámos — código real do repositório vs. desenho aprovado — continua pendente até me enviares esse código depois de o reconstruíres localmente e correres build_runner/analyze/test.
Lembrete importante: ios/ e android/ continuam a precisar de flutter create da tua parte (não gerados aqui, ver instruções da Milestone 01.1); e app_database.g.dart/account_dao.g.dart só existem depois de correres dart run build_runner build --delete-conflicting-outputs.



