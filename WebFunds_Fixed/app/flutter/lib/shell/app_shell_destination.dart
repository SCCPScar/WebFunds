import 'package:flutter/widgets.dart';

import '../design_system/icons/app_icons.dart';

class AppShellDestination {
  const AppShellDestination({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

const List<AppShellDestination> appShellDestinations = [
  AppShellDestination(icon: AppIcons.central, label: 'Central'),
  AppShellDestination(icon: AppIcons.finances, label: 'Finanças'),
  AppShellDestination(icon: AppIcons.vault, label: 'Vault'),
  AppShellDestination(icon: AppIcons.mysteries, label: 'Mistérios'),
  AppShellDestination(icon: AppIcons.weaver, label: 'Weaver'),
];
