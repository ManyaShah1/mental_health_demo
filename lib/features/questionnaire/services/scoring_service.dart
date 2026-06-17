import '../models/scoring_result.dart';

class ScoringService {
  static ScoringResult calculateScore(
    Map<String, dynamic> answers,
  ) {
    int totalScore = 0;

    for (final value in answers.values) {
      if (value is int) {
        totalScore += value;
      }
    }

    SeverityBand severity;

    if (totalScore <= 4) {
      severity = SeverityBand.minimal;
    } else if (totalScore <= 9) {
      severity = SeverityBand.mild;
    } else if (totalScore <= 14) {
      severity = SeverityBand.moderate;
    } else {
      severity = SeverityBand.high;
    }

    return ScoringResult(
      score: totalScore,
      severity: severity,
    );
  }
}