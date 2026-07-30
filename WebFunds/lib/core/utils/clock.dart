/// Abstraction over `DateTime.now()`. Repositories/UseCases that need
/// "the current moment" depend on this — never call `DateTime.now()`
/// directly — so time is controllable in tests.
abstract class Clock {
  DateTime now();
}

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}