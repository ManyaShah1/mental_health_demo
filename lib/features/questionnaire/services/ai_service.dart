import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/text_analysis_result.dart';

class AIService {
  static const String baseUrl = 'https://mental-health-demo.onrender.com';

  /// Sends the collected answers map to the backend for full analysis evaluation
  Future<TextAnalysisResult> analyzeText(Map<String, dynamic> answers) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'answers': answers}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return TextAnalysisResult.fromJson(data);
      } else {
        throw Exception('Server error during assessment analysis');
      }
    } catch (e) {
      print("Error in AIService.analyzeText: $e");
      return const TextAnalysisResult(
        sentiment: 'Unknown',
        themes: ['Unable to analyze assessment summary at this time.'],
        riskFlag: false,
      );
    }
  }
}