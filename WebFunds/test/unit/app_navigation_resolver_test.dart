import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/features/auth/domain/entities/auth_user.dart';
import 'package:webfunds/features/auth/presentation/controllers/auth_gate_controller.dart';
import 'package:webfunds/navigation/app_navigation_context.dart';
import 'package:webfunds/navigation/app_navigation_resolver.dart';
import 'package:webfunds/router/app_routes.dart';

void main() {
  const resolver = AppNavigationResolver();
  const user = AuthUser(id: '1', email: 'scarllett@example.com');

  test('unknown state sends to Splash', () {
    const context =
        AppNavigationContext(authGateState: AuthGateUnknown(), onboardingComplete: true);
    expect(resolver.resolve(context, AppRoutes.central), AppRoutes.splash);
    expect(resolver.resolve(context, AppRoutes.splash), isNull);
  });

  test('unauthenticated sends to Login', () {
    const context =
        AppNavigationContext(authGateState: AuthGateUnauthenticated(), onboardingComplete: true);
    expect(resolver.resolve(context, AppRoutes.central), AppRoutes.login);
  });

  test('awaiting biometric sends to Face ID', () {
    const context = AppNavigationContext(
      authGateState: AuthGateAwaitingBiometric(user),
      onboardingComplete: true,
    );
    expect(resolver.resolve(context, AppRoutes.central), AppRoutes.faceId);
  });

  test('authenticated on a public-only route redirects to Central', () {
    const context =
        AppNavigationContext(authGateState: AuthGateAuthenticated(user), onboardingComplete: true);
    expect(resolver.resolve(context, AppRoutes.login), AppRoutes.central);
    expect(resolver.resolve(context, AppRoutes.splash), AppRoutes.central);
  });

  test('authenticated elsewhere does not force a redirect', () {
    const context =
        AppNavigationContext(authGateState: AuthGateAuthenticated(user), onboardingComplete: true);
    expect(resolver.resolve(context, AppRoutes.central), isNull);
    expect(resolver.resolve(context, AppRoutes.finances), isNull);
  });

  test('authenticated without onboarding complete sends to Onboarding', () {
    const context = AppNavigationContext(
      authGateState: AuthGateAuthenticated(user),
      onboardingComplete: false,
    );
    expect(resolver.resolve(context, AppRoutes.central), AppRoutes.onboarding);
    expect(resolver.resolve(context, AppRoutes.onboarding), isNull);
  });

  test('authenticated with onboarding complete leaves the Onboarding route', () {
    const context =
        AppNavigationContext(authGateState: AuthGateAuthenticated(user), onboardingComplete: true);
    expect(resolver.resolve(context, AppRoutes.onboarding), AppRoutes.central);
  });
}
