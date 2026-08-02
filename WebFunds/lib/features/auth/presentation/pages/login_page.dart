import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/animation/animations.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../services/biometric/biometric_service.dart';
import '../../../../services/logging/app_logger.dart';
import '../../../../shared/widgets/app_offline_banner.dart';
import '../controllers/auth_gate_controller.dart';
import '../controllers/login_controller.dart';
import '../widgets/login_form.dart';

/// The Login screen. Email/password via Supabase Auth (not live yet — no
/// Supabase project exists), with Face ID offered as a shortcut. No
/// screen navigation happens here directly — success reports to
/// `AuthGateController`, and the Route Guard moves the person along.
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  Future<void> _tryBiometricLogin(BuildContext context, WidgetRef ref) async {
    final logger = ref.read(appLoggerProvider);
    try {
      final available = await ref.read(biometricServiceProvider).isAvailable();
      if (!available) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('A biometria não está disponível neste dispositivo.')),
          );
        }
        return;
      }

      final authenticated = await ref
          .read(biometricServiceProvider)
          .authenticate('Confirma a tua identidade para entrar no WebFunds');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authenticated
                  ? 'Biometria confirmada — a ligação a uma sessão guardada ainda não está implementada.'
                  : 'Biometria não confirmada.',
            ),
          ),
        );
      }
    } on BiometricException catch (e) {
      logger.warning(e.message, tag: 'LoginPage');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loginState = ref.watch(loginControllerProvider);

    ref.listen<LoginState>(loginControllerProvider, (previous, next) {
      if (next is LoginFailed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.failure.message)),
        );
      }
      if (next is LoginSuccess) {
        // Tells the browser the credentials just submitted are final —
        // this is what actually triggers Safari's/Chrome's "save
        // password?" prompt. Without it, the browser never learns the
        // autofill session succeeded and never offers to save anything.
        TextInput.finishAutofillContext();
        ref.read(authGateControllerProvider.notifier).markAuthenticated(next.user);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppOfflineBanner(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.xxxl),
                    Icon(
                      AppIcons.central,
                      size: 40,
                      color: theme.colorScheme.primary,
                    ).fadeSlideIn(),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Bem-vinda de volta', style: theme.textTheme.headlineLarge),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Inicia sessão para continuar a tua história financeira.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    LoginForm(
                      isLoading: loginState is LoginLoading,
                      onSubmit: (email, password) {
                        ref
                            .read(loginControllerProvider.notifier)
                            .signIn(email: email, password: password);
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    OutlinedButton.icon(
                      onPressed: () => _tryBiometricLogin(context, ref),
                      icon: const Icon(AppIcons.biometric),
                      label: const Text('Entrar com Face ID'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}