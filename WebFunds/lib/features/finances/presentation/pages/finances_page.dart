import 'package:flutter/material.dart';

import '../../../../design_system/icons/app_icons.dart';
import '../../../../shared/widgets/app_empty_state.dart';

/// Placeholder only — no Domain/Application/Infrastructure layer exists
/// yet for this section. Build those layers when this section's own
/// milestone starts, following the same pattern used in
/// `features/central/` / `features/accounts/`.
class FinancesPage extends StatelessWidget {
  const FinancesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppEmptyState(
      message: 'Finanças chega numa próxima milestone.',
      icon: AppIcons.finances,
    );
  }
}