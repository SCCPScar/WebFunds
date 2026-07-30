import 'package:uuid/uuid.dart';

/// Single point of ID generation for every entity that needs one. Never
/// call `Uuid()` directly anywhere else.
abstract class IdGenerator {
  String generate();
}

class UuidIdGenerator implements IdGenerator {
  const UuidIdGenerator();
  static const _uuid = Uuid();

  @override
  String generate() => _uuid.v4();
}