import 'package:flutter/material.dart';

import '../../../../design_system/icons/app_icons.dart';
import '../../../../shared/widgets/app_empty_state.dart';

/// Placeholder only — ver `FinancesPage` para o raciocínio.
class WeaverPage extends StatelessWidget {
  const WeaverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppEmptyState(
      message: 'Weaver chega numa próxima milestone.',
      icon: AppIcons.weaver,
    );
  }
}