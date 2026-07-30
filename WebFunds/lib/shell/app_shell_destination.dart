import 'package:flutter/widgets.dart';

import '../design_system/icons/app_icons.dart';

/// Data for one Bottom Navigation / Navigation Rail entry. `AppShell`
/// only knows how to lay out a list of these.
class AppShellDestination {
  const AppShellDestination({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// The 5 documented sections, in display order. Order here must match
/// the branch order in `router/app_router.dart`'s `StatefulShellRoute`.
const List<AppShellDestination> appShellDestinations = [
  AppShellDestination(icon: AppIcons.central, label: 'Central'),
  AppShellDestination(icon: AppIcons.finances, label: 'Finanças'),
  AppShellDestination(icon: AppIcons.vault, label: 'Vault'),
  AppShellDestination(icon: AppIcons.mysteries, label: 'Mistérios'),
  AppShellDestination(icon: AppIcons.weaver, label: 'Weaver'),
];