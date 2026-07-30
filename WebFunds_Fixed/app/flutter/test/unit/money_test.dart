import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/shared/models/money.dart';

void main() {
  group('Money', () {
    test('fromMajorUnits converts correctly to minor units', () {
      expect(Money.fromMajorUnits(12.34).minorUnits, 1234);
      expect(Money.fromMajorUnits(0).minorUnits, 0);
      expect(Money.fromMajorUnits(-5.5).minorUnits, -550);
    });

    test('format renders sign, currency and 2 decimals', () {
      expect(Money.fromMajorUnits(1284.3).format(), '€ 1284.30');
      expect(Money.fromMajorUnits(-42).format(), '-€ 42.00');
    });

    test('arithmetic operators work on same currency', () {
      final a = Money.fromMajorUnits(10);
      final b = Money.fromMajorUnits(4);
      expect((a + b).majorUnits, 14);
      expect((a - b).majorUnits, 6);
      expect((-a).majorUnits, -10);
      expect(a.negate().majorUnits, -10);
      expect(Money.fromMajorUnits(-7).abs().majorUnits, 7);
    });

    test('comparison operators and Comparable', () {
      final a = Money.fromMajorUnits(5);
      final b = Money.fromMajorUnits(10);
      expect(a < b, isTrue);
      expect(b > a, isTrue);
      expect(a <= a, isTrue);
      expect(b >= b, isTrue);
      expect(a.compareTo(b), lessThan(0));
      expect([b, a]..sort(), [a, b]);
    });

    test('copyWith overrides only the given field', () {
      final original = Money.fromMajorUnits(10, currency: '€');
      final copy = original.copyWith(minorUnits: 500);
      expect(copy.majorUnits, 5);
      expect(copy.currency, '€');
    });

    test('isNegative / isPositive / isZero', () {
      expect(Money.fromMajorUnits(-1).isNegative, isTrue);
      expect(Money.fromMajorUnits(1).isPositive, isTrue);
      expect(Money.zero().isZero, isTrue);
    });

    test('equality is value-based', () {
      expect(Money.fromMajorUnits(10), Money.fromMajorUnits(10));
      expect(Money.fromMajorUnits(10) == Money.fromMajorUnits(10, currency: '\$'), isFalse);
    });
  });
}
