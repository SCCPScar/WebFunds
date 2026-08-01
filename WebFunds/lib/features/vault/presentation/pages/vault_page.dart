import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/icons/app_icons.dart';
import '../../../dreams/presentation/pages/dreams_page.dart';

/// Vault is this app's name for the "reserve money for future goals"
/// experience (`docs/01-Experience/04-Vault.md`) — the same feature the
/// domain layer calls Dreams (`docs/02-Domain/04-Dreams.md`; the
/// Navigation doc's deep-link list even calls one "A Vault Goal"). No
/// separate entity exists for "Vault Goal" — this tab just reuses
/// Dreams' list/create/detail flows directly, without a second Scaffold/
/// AppBar (`AppShell` already supplies one for every shell branch).
class VaultPage extends ConsumerWidget {
  const VaultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => openCreateDreamForm(context, ref),
        tooltip: 'Adicionar objetivo',
        child: const Icon(AppIcons.add),
      ),
      body: const DreamsListBody(),
    );
  }
}
