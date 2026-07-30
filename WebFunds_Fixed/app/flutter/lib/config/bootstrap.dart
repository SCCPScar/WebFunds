import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app.dart';
import '../services/supabase/supabase_service.dart';
import 'environment.dart';
import 'env_config.dart';

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
