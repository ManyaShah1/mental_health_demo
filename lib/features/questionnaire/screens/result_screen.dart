import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../models/text_analysis_result.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> answers;
  final AIService _aiService = AIService();

  ResultScreen({super.key, required this.answers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Assessment Results'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<TextAnalysisResult>(
        future: _aiService.analyzeText(answers),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF23C4C8)),
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error generating evaluation dashboard report.'));
          }

          final report = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: const Color(0xFFF4EEFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const Icon(Icons.analytics, color: Color(0xFF23C4C8), size: 36),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Severity Level', style: TextStyle(fontSize: 14, color: Colors.grey)),
                            Text(
                              report.sentiment, // Maps to severity key string returned by Gemini
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Text('Summary Metrics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(
                  report.themes.isNotEmpty ? report.themes.join(', ') : 'No data summarized.',
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}