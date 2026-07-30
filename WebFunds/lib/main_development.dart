import 'config/bootstrap.dart';
import 'config/environment.dart';

/// Run with:
/// `flutter run --target lib/main_development.dart --dart-define-from-file=env/development.json`
void main() => bootstrapApp(AppEnvironment.development);