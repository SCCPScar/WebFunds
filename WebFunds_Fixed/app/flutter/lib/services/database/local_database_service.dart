abstract class LocalDatabaseService {
  Future<void> initialize();
  Future<void> close();
}
