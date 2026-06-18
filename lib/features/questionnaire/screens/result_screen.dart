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
      body: FutureBuilder<TextAnalysisResult>(
        future: _aiService.analyzeText(answers),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF23C4C8)),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Analyzing responses...',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  )
                ],
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error generating evaluation report.'));
          }

          final report = snapshot.data!;

          return SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 550),
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Assessment",
                        style: TextStyle(fontSize: 14, color: Colors.grey, letterSpacing: 1.2),
                      ),
                      const Text(
                        "Your Insights",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 25),

                      // Numerical Score circular Dashboard card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "${report.totalScore}",
                              style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Color(0xFF23C4C8)),
                            ),
                            const Text(
                              "Overall Wellness Score",
                              style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: _getSeverityColor(report.severity).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${report.severity} Severity Profile",
                                style: TextStyle(color: _getSeverityColor(report.severity), fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Narrative Summary Analysis
                      const Text("Summary Analysis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text(
                        report.summary,
                        style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                      ),
                      const SizedBox(height: 30),

                      // Diagnostic Metrics Sections
                      const Text("Diagnostic Metrics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      ...report.metrics.entries.map((entry) => _buildMetricRow(entry.key, entry.value)),
                      const SizedBox(height: 30),

                      // Actionable Plan Frameworks
                      const Text("Actionable Frameworks", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      ...report.recommendations.map((rec) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_outline, color: Color(0xFF23C4C8), size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(rec, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4)),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.redAccent;
      case 'moderate':
        return Colors.orangeAccent;
      default:
        return const Color(0xFF23C4C8);
    }
  }

  Widget _buildMetricRow(String name, int val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Fixed parameter alignment syntax mapping
            children: [
              Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              Text("$val/10", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: val / 10,
              minHeight: 8,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF23C4C8)),
            ),
          )
        ],
      ),
    );
  }
}