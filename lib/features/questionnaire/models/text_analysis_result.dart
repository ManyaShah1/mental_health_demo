class TextAnalysisResult {
  final String sentiment;
  final List<String> themes;
  final bool riskFlag;

  const TextAnalysisResult({
    required this.sentiment,
    required this.themes,
    required this.riskFlag,
  });

  factory TextAnalysisResult.fromJson(Map<String, dynamic> json) {
    // Map the backend's severity -> sentiment, and recommendations -> themes gracefully
    return TextAnalysisResult(
      sentiment: json['severity'] as String? ?? json['sentiment'] as String? ?? 'Low',
      themes: List<String>.from(json['recommendations'] ?? json['themes'] ?? []),
      riskFlag: json['riskFlag'] as bool? ?? (json['severity'] == 'High'),
    );
  }
}