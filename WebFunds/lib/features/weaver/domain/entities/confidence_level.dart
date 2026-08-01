/// `docs/02-Domain/06-Weaver.md` Confidence Model — every suggestion
/// carries one of these, derived from a 0-100 score.
enum ConfidenceLevel { veryHigh, high, medium, low, veryLow }

extension ConfidenceLevelFromScore on ConfidenceLevel {
  static ConfidenceLevel fromScore(int score) {
    if (score >= 95) return ConfidenceLevel.veryHigh;
    if (score >= 80) return ConfidenceLevel.high;
    if (score >= 60) return ConfidenceLevel.medium;
    if (score >= 40) return ConfidenceLevel.low;
    return ConfidenceLevel.veryLow;
  }
}
