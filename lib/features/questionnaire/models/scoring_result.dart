enum SeverityBand { minimal, mild, moderate, high }

class ScoringResult {
  final int score;
  final SeverityBand severity;

  const ScoringResult({required this.score, required this.severity});
}