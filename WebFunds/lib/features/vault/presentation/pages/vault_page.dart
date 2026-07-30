import 'package:flutter/material.dart';

import '../../../../design_system/icons/app_icons.dart';
import '../../../../shared/widgets/app_empty_state.dart';

/// Placeholder only — ver `FinancesPage` para o raciocínio.
class VaultPage extends StatelessWidget {
  const VaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppEmptyState(
      message: 'Vault chega numa próxima milestone.',
      icon: AppIcons.vault,
    );
  }
}