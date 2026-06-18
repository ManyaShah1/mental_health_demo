class TextAnalysisResult {
  final int totalScore;
  final String severity;
  final String summary;
  final Map<String, int> metrics;
  final List<String> recommendations;

  const TextAnalysisResult({
    required this.totalScore,
    required this.severity,
    required this.summary,
    required this.metrics,
    required this.recommendations,
  });

  factory TextAnalysisResult.fromJson(Map<String, dynamic> json) {
    return TextAnalysisResult(
      totalScore: json['total_score'] as int? ?? json['totalScore'] as int? ?? 0,
      severity: json['severity'] as String? ?? 'Low',
      summary: json['summary'] as String? ?? '',
      metrics: Map<String, int>.from(json['metrics'] ?? {
        "Mood Balance": 0,
        "Sleep Architecture": 0,
        "Stress Resilience": 0,
        "Cognitive Focus": 0,
        "Anxiety Management": 0
      }),
      recommendations: List<String>.from(json['recommendations'] ?? []),
    );
  }
}