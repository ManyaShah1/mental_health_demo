import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/text_analysis_result.dart';
import 'config.dart'; // Make sure this points to your ApiConfig file

class AIService {
  // Uses centralized config baseUrl. Make sure it points to your live Render backend!
  static const String baseUrl = ApiConfig.baseUrl;

  Future<TextAnalysisResult> analyzeText(Map<String, dynamic> answers) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'answers': answers}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return TextAnalysisResult.fromJson(data);
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error in AIService.analyzeText: $e");
      return const TextAnalysisResult(
        totalScore: 0,
        severity: 'Unknown',
        summary: 'Unable to safely process and compile evaluation parameters at this time.',
        metrics: {
          "Mood Balance": 0,
          "Sleep Architecture": 0,
          "Stress Resilience": 0,
          "Cognitive Focus": 0,
          "Anxiety Management": 0
        },
        recommendations: ['Please try reloading your assessment report panel shortly.'],
      );
    }
  }
}