/// Contract every future concrete local-database implementation follows.
/// `AppDatabase` (Drift) implements this — see `app_database.dart`.
abstract class LocalDatabaseService {
  Future<void> initialize();
  Future<void> close();
}