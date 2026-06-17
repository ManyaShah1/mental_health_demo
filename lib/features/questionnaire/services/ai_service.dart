import '../models/text_analysis_result.dart';

class AIService {
  Future<TextAnalysisResult> analyzeText(
    String text,
  ) async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    return const TextAnalysisResult(
      sentiment: 'Negative',
      themes: [
        'Stress',
        'Fatigue',
        'Anxiety',
      ],
      riskFlag: false,
    );
  }
}