import '../features/auth/presentation/controllers/auth_gate_controller.dart';

class AppNavigationContext {
  const AppNavigationContext({required this.authGateState});

  final AuthGateState authGateState;
}
