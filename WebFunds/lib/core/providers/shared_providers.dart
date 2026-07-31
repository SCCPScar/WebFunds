import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/database/app_database.dart';
import '../utils/clock.dart';
import '../utils/id_generator.dart';

/// App-wide infrastructure providers every local-persistence feature
/// depends on. Kept in one place so every feature shares the same
/// `AppDatabase` instance — opening a second one against the same
/// underlying file risks the race conditions Drift itself warns about.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final idGeneratorProvider = Provider<IdGenerator>((ref) => const UuidIdGenerator());

final clockProvider = Provider<Clock>((ref) => const SystemClock());
