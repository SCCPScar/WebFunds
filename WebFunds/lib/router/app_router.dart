import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../config/env_config.dart';
import '../core/animation/page_transitions.dart';
import '../core/errors/failure.dart';
import '../features/accounts/presentation/pages/accounts_page.dart';
import '../features/auth/presentation/controllers/auth_gate_controller.dart';
import '../features/auth/presentation/pages/face_id_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/central/presentation/pages/central_page.dart';
import '../features/dreams/presentation/pages/dreams_page.dart';
import '../features/finances/presentation/pages/finances_page.dart';
import '../features/mysteries/presentation/pages/mysteries_page.dart';
import '../features/notifications/presentation/pages/notification_center_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/subscriptions/presentation/pages/subscriptions_page.dart';
import '../features/vault/presentation/pages/vault_page.dart';
import '../features/weaver/presentation/pages/weaver_page.dart';
import '../navigation/app_navigation_context.dart';
import '../navigation/app_navigation_resolver_provider.dart';
import '../shared/widgets/app_error_view.dart';
import '../shell/app_shell.dart';
import 'app_routes.dart';

/// Bridges `authGateControllerProvider` changes into a `Listenable`
/// GoRouter can use as `refreshListenable`, so `redirect` re-runs whenever
/// the gate state changes.
class _AuthGateRefreshNotifier extends ChangeNotifier {
  _AuthGateRefreshNotifier(Ref ref) {
    _subscription = ref.listen<AuthGateState>(
      authGateControllerProvider,
      (previous, next) => notifyListeners(),
    );
  }

  late final ProviderSubscription<AuthGateState> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}

/// WebFunds router configuration. The router only delegates navigation
/// decisions to `AppNavigationResolver` — it holds no auth/business logic
/// of its own.
final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _AuthGateRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: EnvConfig.environment.isDebuggable,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final navigationContext = AppNavigationContext(
        authGateState: ref.read(authGateControllerProvider),
      );
      return ref
          .read(appNavigationResolverProvider)
          .resolve(navigationContext, state.matchedLocation);
    },
    errorBuilder: (context, state) => AppErrorView(
      failure: UnknownFailure(message: 'Página não encontrada: ${state.uri}'),
    ),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splashName,
        pageBuilder: (context, state) =>
            PageTransitions.fade(key: state.pageKey, child: const SplashPage()),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        pageBuilder: (context, state) =>
            PageTransitions.fadeThroughSlide(key: state.pageKey, child: const LoginPage()),
      ),
      GoRoute(
        path: AppRoutes.faceId,
        name: AppRoutes.faceIdName,
        pageBuilder: (context, state) =>
            PageTransitions.fade(key: state.pageKey, child: const FaceIdPage()),
      ),
      GoRoute(
        path: AppRoutes.accounts,
        name: AppRoutes.accountsName,
        pageBuilder: (context, state) =>
            PageTransitions.fadeThroughSlide(key: state.pageKey, child: const AccountsPage()),
      ),
      GoRoute(
        path: AppRoutes.dreams,
        name: AppRoutes.dreamsName,
        pageBuilder: (context, state) =>
            PageTransitions.fadeThroughSlide(key: state.pageKey, child: const DreamsPage()),
      ),
      GoRoute(
        path: AppRoutes.subscriptions,
        name: AppRoutes.subscriptionsName,
        pageBuilder: (context, state) =>
            PageTransitions.fadeThroughSlide(key: state.pageKey, child: const SubscriptionsPage()),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: AppRoutes.profileName,
        pageBuilder: (context, state) =>
            PageTransitions.fadeThroughSlide(key: state.pageKey, child: const ProfilePage()),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: AppRoutes.notificationsName,
        pageBuilder: (context, state) => PageTransitions.fadeThroughSlide(
          key: state.pageKey,
          child: const NotificationCenterPage(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.central,
                name: AppRoutes.centralName,
                builder: (context, state) => const CentralPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.finances,
                name: AppRoutes.financesName,
                builder: (context, state) => const FinancesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.vault,
                name: AppRoutes.vaultName,
                builder: (context, state) => const VaultPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.mysteries,
                name: AppRoutes.mysteriesName,
                builder: (context, state) => const MysteriesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.weaver,
                name: AppRoutes.weaverName,
                builder: (context, state) => const WeaverPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
