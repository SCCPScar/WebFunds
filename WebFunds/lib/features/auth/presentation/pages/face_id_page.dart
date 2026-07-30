import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/animation/animations.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../services/biometric/biometric_service.dart';
import '../../../../services/logging/app_logger.dart';
import '../../domain/entities/auth_user.dart';
import '../controllers/auth_gate_controller.dart';

/// Shown when `AuthGateController` finds an existing session with Face ID
/// enabled. Success/fallback report to `AuthGateController` — no direct
/// navigation happens here, the Route Guard reacts to the state change.
class FaceIdPage extends ConsumerWidget {
  const FaceIdPage({super.key, required this.user});

  final AuthUser user;

  Future<void> _authenticate(BuildContext context, WidgetRef ref) async {
    final logger = ref.read(appLoggerProvider);
    try {
      final authenticated = await ref
          .read(biometricServiceProvider)
          .authenticate('Confirma a tua identidade para continuar como ${user.email}');

      if (authenticated) {
        ref.read(authGateControllerProvider.notifier).markUnlocked();
        return;
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Biometria não confirmada.')));
      }
    } on BiometricException catch (e) {
      logger.warning(e.message, tag: 'FaceIdPage');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                AppIcons.biometric,
                size: 48,
                color: theme.colorScheme.primary,
              ).fadeSlideIn(),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Bem-vinda de volta',
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(user.email, style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xxxl),
              ElevatedButton.icon(
                onPressed: () => _authenticate(context, ref),
                icon: const Icon(AppIcons.biometric),
                label: const Text('Usar Face ID'),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextButton(
                onPressed: () =>
                    ref.read(authGateControllerProvider.notifier).requestPasswordFallback(),
                child: const Text('Entrar com palavra-passe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}