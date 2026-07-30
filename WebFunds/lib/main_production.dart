import 'config/bootstrap.dart';
import 'config/environment.dart';

/// Run with:
/// `flutter run --target lib/main_production.dart --dart-define-from-file=env/production.json`
void main() => bootstrapApp(AppEnvironment.production);