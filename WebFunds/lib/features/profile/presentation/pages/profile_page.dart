import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/icons/app_icons.dart';
import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../theme/theme_mode_provider.dart';
import '../../../auth/presentation/controllers/auth_gate_controller.dart';

/// A lean slice of `docs/01-Experience/07-Profile.md` — the "control
/// center" doc describes Connected Banks, Security, Weaver Settings,
/// Data & Privacy and Backup/Export sections that all depend on features
/// this app doesn't have yet (Banking, per-device biometric settings
/// beyond the existing Face ID toggle, Weaver learning controls). This
/// page covers only what's real right now: who's signed in, Appearance
/// (already backed by `themeModeProvider`), and signing out — the one
/// action this app was missing entirely before this page existed.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Terminar sessão'),
        content: const Text('Tens a certeza que queres terminar a sessão?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Terminar sessão'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authGateControllerProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authGateControllerProvider);
    final email = switch (authState) {
      AuthGateAuthenticated(:final user) => user.email,
      AuthGateAwaitingBiometric(:final user) => user.email,
      _ => null,
    };
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(AppIcons.profile, color: theme.colorScheme.primary, size: 32),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Text(
                      email ?? 'Sem sessão',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Aparência', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.system, label: Text('Sistema')),
                  ButtonSegment(value: ThemeMode.light, label: Text('Claro')),
                  ButtonSegment(value: ThemeMode.dark, label: Text('Escuro')),
                ],
                selected: {themeMode},
                onSelectionChanged: (selection) =>
                    ref.read(themeModeProvider.notifier).setThemeMode(selection.first),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Sobre', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          const Card(
            child: ListTile(title: Text('WebFunds'), subtitle: Text('Versão 0.1.0')),
          ),
          const SizedBox(height: AppSpacing.xl),
          OutlinedButton(
            onPressed: () => _confirmSignOut(context, ref),
            child: const Text('Terminar sessão'),
          ),
        ],
      ),
    );
  }
}
