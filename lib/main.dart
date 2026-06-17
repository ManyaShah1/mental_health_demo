import 'package:flutter/material.dart';

import 'features/questionnaire/screens/questionnaire_screen.dart';

void main() {
  runApp(const MentalHealthApp());
}

class MentalHealthApp extends StatelessWidget {
  const MentalHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Mental Health AI',

      theme: ThemeData(
        useMaterial3: true,
      ),

      home: const QuestionnaireScreen(),
    );
  }
}