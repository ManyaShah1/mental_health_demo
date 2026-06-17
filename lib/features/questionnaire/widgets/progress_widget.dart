import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  final double progress;
  final int current;
  final int total;

  const ProgressWidget({
    super.key,
    required this.progress,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          "Question $current of $total",
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius:
              BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            color: const Color(0xFF23C4C8),
            backgroundColor:
                Colors.grey.shade200,
          ),
        ),
      ],
    );
  }
}