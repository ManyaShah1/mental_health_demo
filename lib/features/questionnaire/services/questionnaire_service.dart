import 'dart:convert';
import 'package:http/http.dart' as http;

class QuestionnaireService {
  static const String baseUrl =
      'http://127.0.0.1:8000';

  Future<Map<String, dynamic>>
      getNextQuestion(
    Map<String, dynamic> answers,
  ) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/next-question',
      ),
      headers: {
        'Content-Type':
            'application/json',
      },
      body: jsonEncode({
        'answers': answers,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>>
      analyzeAssessment(
    Map<String, dynamic> answers,
  ) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/analyze',
      ),
      headers: {
        'Content-Type':
            'application/json',
      },
      body: jsonEncode({
        'answers': answers,
      }),
    );

    return jsonDecode(response.body);
  }
}