import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/services/logging/app_logger.dart';
import 'package:webfunds/startup/startup_coordinator.dart';
import 'package:webfunds/startup/startup_result.dart';
import 'package:webfunds/startup/startup_task.dart';

class _FakeSilentLogger implements AppLogger {
  @override
  void debug(String message, {String? tag}) {}
  @override
  void info(String message, {String? tag}) {}
  @override
  void warning(String message, {String? tag}) {}
  @override
  void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {}
}

class _FakeTask extends StartupTask {
  const _FakeTask(this.name, this._apply);
  @override
  final String name;
  final void Function(StartupResultBuilder builder) _apply;

  @override
  Future<void> run(StartupResultBuilder builder) async => _apply(builder);
}

class _FailingTask extends StartupTask {
  const _FailingTask();
  @override
  String get name => 'Failing';
  @override
  Future<void> run(StartupResultBuilder builder) async => throw Exception('boom');
}

void main() {
  test('runs every task and assembles a single StartupResult', () async {
    final coordinator = StartupCoordinator([
      _FakeTask('A', (b) => b.sessionUser = null),
    ], _FakeSilentLogger());

    final result = await coordinator.run();

    expect(result.hasSession, isFalse);
  });

  test('one failing task does not stop the others or crash the app', () async {
    var otherTaskRan = false;
    final coordinator = StartupCoordinator([
      const _FailingTask(),
      _FakeTask('B', (b) => otherTaskRan = true),
    ], _FakeSilentLogger());

    final result = await coordinator.run();

    expect(otherTaskRan, isTrue);
    expect(result, isNotNull);
  });
}
