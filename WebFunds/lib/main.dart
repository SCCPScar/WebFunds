import 'main_development.dart' as development;

/// Default entry point — kept so `flutter run` with no `--target` still
/// works. Forwards to the Development flavor. CI/release builds should
/// target `main_staging.dart` / `main_production.dart` explicitly.
void main() => development.main();