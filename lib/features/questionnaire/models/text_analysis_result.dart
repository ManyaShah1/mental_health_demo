class TextAnalysisResult {
  final String sentiment;
  final List<String> themes;
  final bool riskFlag;

  const TextAnalysisResult({
    required this.sentiment,
    required this.themes,
    required this.riskFlag,
  });
}
