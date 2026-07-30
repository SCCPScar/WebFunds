import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app.dart';
import '../services/supabase/supabase_service.dart';
import 'environment.dart';
import 'env_config.dart';

/// Shared startup sequence for every environment. `SupabaseService.initialize()`
/// runs here — safe even when `env/*.json` is empty, since it detects
/// "not configured" and returns without throwing. A `ProviderContainer`
/// is created manually so we can `await` this before the first frame.
Future<void> bootstrapApp(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  EnvConfig.setEnvironment(environment);

  final container = ProviderContainer();
  await container.read(supabaseServiceProvider).initialize();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const WebFundsApp(),
    ),
  );
}