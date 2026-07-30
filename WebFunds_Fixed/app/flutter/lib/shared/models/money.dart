class Money implements Comparable<Money> {
  const Money._(this.minorUnits, this.currency);

  final int minorUnits;
  final String currency;

  factory Money.fromMajorUnits(double amount, {String currency = '€'}) {
    return Money._((amount * 100).round(), currency);
  }

  factory Money.fromMinorUnits(int minorUnits, {String currency = '€'}) {
    return Money._(minorUnits, currency);
  }

  static Money zero({String currency = '€'}) => Money._(0, currency);

  double get majorUnits => minorUnits / 100;

  bool get isNegative => minorUnits < 0;
  bool get isPositive => minorUnits > 0;
  bool get isZero => minorUnits == 0;

  Money copyWith({int? minorUnits, String? currency}) {
    return Money._(minorUnits ?? this.minorUnits, currency ?? this.currency);
  }

  Money abs() => Money._(minorUnits.abs(), currency);

  Money negate() => Money._(-minorUnits, currency);

  Money operator +(Money other) {
    _assertSameCurrency(other, 'add');
    return Money._(minorUnits + other.minorUnits, currency);
  }

  Money operator -(Money other) {
    _assertSameCurrency(other, 'subtract');
    return Money._(minorUnits - other.minorUnits, currency);
  }

  Money operator -() => negate();

  bool operator <(Money other) {
    _assertSameCurrency(other, 'compare');
    return minorUnits < other.minorUnits;
  }

  bool operator <=(Money other) {
    _assertSameCurrency(other, 'compare');
    return minorUnits <= other.minorUnits;
  }

  bool operator >(Money other) {
    _assertSameCurrency(other, 'compare');
    return minorUnits > other.minorUnits;
  }

  bool operator >=(Money other) {
    _assertSameCurrency(other, 'compare');
    return minorUnits >= other.minorUnits;
  }

  @override
  int compareTo(Money other) {
    _assertSameCurrency(other, 'compare');
    return minorUnits.compareTo(other.minorUnits);
  }

  void _assertSameCurrency(Money other, String operation) {
    assert(
      currency == other.currency,
      'Cannot $operation Money with different currencies ($currency vs ${other.currency})',
    );
  }

  String format() {
    final sign = isNegative ? '-' : '';
    return '$sign$currency ${majorUnits.abs().toStringAsFixed(2)}';
  }

  @override
  bool operator ==(Object other) =>
      other is Money && other.minorUnits == minorUnits && other.currency == currency;

  @override
  int get hashCode => Object.hash(minorUnits, currency);

  @override
  String toString() => format();
}
