import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design_system/breakpoints/app_breakpoints.dart';
import '../shared/widgets/app_offline_banner.dart';
import 'app_shell_destination.dart';

/// The app's definitive structural shell — AppBar + Bottom Navigation
/// (phone) / Navigation Rail (tablet), wrapping GoRouter's
/// `StatefulNavigationShell`. Knows only how to lay these out — tab
/// content lives in `app_shell_destination.dart`, and each branch's
/// screen lives in its own feature.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).width >= AppBreakpoints.tablet;
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      appBar: AppBar(title: Text(appShellDestinations[currentIndex].label)),
      body: Column(
        children: [
          const AppOfflineBanner(),
          Expanded(
            child: isTablet
                ? Row(
                    children: [
                      NavigationRail(
                        selectedIndex: currentIndex,
                        onDestinationSelected: _onDestinationSelected,
                        labelType: NavigationRailLabelType.all,
                        destinations: [
                          for (final d in appShellDestinations)
                            NavigationRailDestination(icon: Icon(d.icon), label: Text(d.label)),
                        ],
                      ),
                      const VerticalDivider(width: 1),
                      Expanded(child: navigationShell),
                    ],
                  )
                : navigationShell,
          ),
        ],
      ),
      bottomNavigationBar: isTablet
          ? null
          : NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: _onDestinationSelected,
              destinations: [
                for (final d in appShellDestinations)
                  NavigationDestination(icon: Icon(d.icon), label: d.label),
              ],
            ),
    );
  }
}