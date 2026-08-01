import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../design_system/breakpoints/app_breakpoints.dart';
import '../design_system/icons/app_icons.dart';
import '../features/notifications/presentation/controllers/notification_providers.dart';
import '../router/app_routes.dart';
import '../shared/widgets/app_offline_banner.dart';
import 'app_shell_destination.dart';

/// The app's definitive structural shell — AppBar + Bottom Navigation
/// (phone) / Navigation Rail (tablet), wrapping GoRouter's
/// `StatefulNavigationShell`. Knows only how to lay these out — tab
/// content lives in `app_shell_destination.dart`, and each branch's
/// screen lives in its own feature.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTablet = MediaQuery.sizeOf(context).width >= AppBreakpoints.tablet;
    final currentIndex = navigationShell.currentIndex;
    final unreadCount = ref.watch(unreadNotificationCountProvider).value?.dataOrNull ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(appShellDestinations[currentIndex].label),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: unreadCount > 0,
              label: Text('$unreadCount'),
              child: const Icon(AppIcons.notifications),
            ),
            tooltip: 'Notificações',
            onPressed: () => context.push(AppRoutes.notifications),
          ),
          IconButton(
            icon: const Icon(AppIcons.profile),
            tooltip: 'Perfil',
            onPressed: () => context.push(AppRoutes.profile),
          ),
        ],
      ),
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
