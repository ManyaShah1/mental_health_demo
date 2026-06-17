import 'scoring_result.dart';
import 'text_analysis_result.dart';

/// Combined output of a completed questionnaire session.
class QuestionnaireResult {
  final ScoringResult scoring;
  final TextAnalysisResult textAnalysis;

  const QuestionnaireResult({required this.scoring, required this.textAnalysis});

  /// True if either the deterministic score or the text analysis
  /// suggests this response should be routed to a human/crisis flow.
  /// Deliberately an OR of two independent signals rather than relying
  /// on the model alone for a safety-relevant decision.
  bool get requiresEscalation =>
      textAnalysis.riskFlag || scoring.severity == SeverityBand.high;
}