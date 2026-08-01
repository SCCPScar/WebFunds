import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_navigation_resolver.dart';

final appNavigationResolverProvider = Provider<AppNavigationResolver>((ref) {
  return const AppNavigationResolver();
});
