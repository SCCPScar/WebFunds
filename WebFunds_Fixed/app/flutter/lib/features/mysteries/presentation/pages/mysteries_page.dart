import 'package:flutter/material.dart';

import '../../../../design_system/icons/app_icons.dart';
import '../../../../shared/widgets/app_empty_state.dart';

class MysteriesPage extends StatelessWidget {
  const MysteriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppEmptyState(
      message: 'Mistérios chega numa próxima milestone.',
      icon: AppIcons.mysteries,
    );
  }
}
