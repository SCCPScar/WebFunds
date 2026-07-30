import '../features/auth/presentation/controllers/auth_gate_controller.dart';
import '../router/app_routes.dart';
import 'app_navigation_context.dart';

class AppNavigationResolver {
  const AppNavigationResolver();

  static const _publicOnlyRoutes = {AppRoutes.splash, AppRoutes.login, AppRoutes.faceId};

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
