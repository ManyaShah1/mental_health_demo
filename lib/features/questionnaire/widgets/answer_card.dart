import 'package:flutter/material.dart';

class AnswerCard extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const AnswerCard({
    super.key,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius:
          BorderRadius.circular(20),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding:
              const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}