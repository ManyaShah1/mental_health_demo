import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> answers;

  const ResultScreen({
    super.key,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 80),

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(24),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff34D399),
                    Color(0xff10B981),
                  ],
                ),

                borderRadius:
                    BorderRadius.circular(
                  24,
                ),
              ),

              child: const Column(
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 60,
                  ),

                  SizedBox(height: 12),

                  Text(
                    "Assessment Complete",

                    style: TextStyle(
                      color:
                          Colors.white,
                      fontSize: 24,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            _infoCard(
              "Emotional State",
              "Moderate Stress",
              const Color(
                0xff8B5CF6,
              ),
            ),

            _infoCard(
              "Risk Level",
              "Low",
              const Color(
                0xff60A5FA,
              ),
            ),

            _infoCard(
              "Recommendation",
              "Focus on sleep, hydration and mindfulness exercises.",
              const Color(
                0xffFBBF24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
    String title,
    String value,
    Color color,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),

      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: color.withOpacity(0.15),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}