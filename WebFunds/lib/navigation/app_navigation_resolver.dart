import '../features/auth/presentation/controllers/auth_gate_controller.dart';
import '../router/app_routes.dart';
import 'app_navigation_context.dart';

/// Decides the app's current destination. Holds no reference to GoRouter
/// or Riverpod — a pure function of [AppNavigationContext] plus the
/// location currently being navigated to. The router's `redirect`
/// callback does nothing but call [resolve] and return its answer.
///
/// Evolution note (approved but not yet needed): once navigation signals
/// grow beyond auth (Maintenance Mode, Mandatory Update, Onboarding,
/// Profile Completeness, Subscription, ...), extract each decision into
/// an independent `NavigationRule` and have this resolver iterate a
/// priority-ordered list of them, instead of one growing `switch`. With
/// today's single signal (auth), that would be premature — revisit when
/// the second or third real signal lands.
class AppNavigationResolver {
  const AppNavigationResolver();

  static const _publicOnlyRoutes = {AppRoutes.splash, AppRoutes.login, AppRoutes.faceId};

  /// Returns the location the app should be at, or `null` if
  /// [currentLocation] is already correct.
  String? resolve(AppNavigationContext context, String currentLocation) {
    final required = _requiredDestination(context);

    if (required != null) {
      return currentLocation == required ? null : required;
    }

    if (_publicOnlyRoutes.contains(currentLocation)) {
      return AppRoutes.central;
    }

    return null;
  }

  String? _requiredDestination(AppNavigationContext context) {
    return switch (context.authGateState) {
      AuthGateUnknown() => AppRoutes.splash,
      AuthGateUnauthenticated() => AppRoutes.login,
      AuthGateAwaitingBiometric() => AppRoutes.faceId,
      AuthGateAuthenticated() => null,
    };
  }
}