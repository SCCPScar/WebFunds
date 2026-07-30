import 'config/bootstrap.dart';
import 'config/environment.dart';

/// Run with:
/// `flutter run --target lib/main_staging.dart --dart-define-from-file=env/staging.json`
void main() => bootstrapApp(AppEnvironment.staging);