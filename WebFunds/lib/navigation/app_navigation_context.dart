import '../features/auth/presentation/controllers/auth_gate_controller.dart';

/// Everything `AppNavigationResolver` needs to decide the app's current
/// destination. One field per independent signal — adding Mandatory
/// Update, Maintenance Mode, or Incomplete Profile later means adding a
/// field here, not changing the resolver's method signature.
class AppNavigationContext {
  const AppNavigationContext({required this.authGateState, required this.onboardingComplete});

  final AuthGateState authGateState;

  /// Only meaningful once `authGateState` is `AuthGateAuthenticated` —
  /// Onboarding never gates Login/Face ID.
  final bool onboardingComplete;

  // Future fields, added one at a time as each becomes real:
  // final bool maintenanceModeActive;
  // final bool mandatoryUpdateRequired;
  // final bool profileComplete;
}
