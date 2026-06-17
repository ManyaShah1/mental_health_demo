import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final String question;

  const QuestionCard({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(
          0xFFF4EEFF,
        ),
        borderRadius:
            BorderRadius.circular(24),
      ),
      child: Text(
        question,
        style: const TextStyle(
          fontSize: 22,
          fontWeight:
              FontWeight.w600,
        ),
      ),
    );
  }
}