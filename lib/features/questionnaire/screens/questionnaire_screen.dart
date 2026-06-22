import 'package:flutter/material.dart';
import '../controllers/questionnaire_controller.dart';
import '../models/question.dart';
import '../widgets/answer_card.dart';
import '../widgets/assessment_header.dart';
import '../widgets/progress_widget.dart';
import '../widgets/question_card.dart';
import 'result_screen.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final QuestionnaireController controller = QuestionnaireController();

  @override
  void initState() {
    super.initState();
    controller.addListener(_onControllerStateChanged);
    controller.initializeQuestionnaire();
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerStateChanged);
    super.dispose();
  }

  void _onControllerStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (controller.isFinished) {
      return ResultScreen(answers: controller.answers);
    }

    final question = controller.currentQuestion;

    if (controller.isLoading || question == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF23C4C8)),
          ),
        ),
      );
    }

    // Progress tracks directly with the answers map count
    int currentIndex = controller.answers.length + 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 550),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const AssessmentHeader(),
                const SizedBox(height: 25),
                ProgressWidget(
                  progress: currentIndex / 15,
                  current: currentIndex > 15 ? 15 : currentIndex,
                  total: 15,
                ),
                const SizedBox(height: 25),
                QuestionCard(question: question.prompt),
                const SizedBox(height: 20),
                Expanded(
                  child: question.type == QuestionType.scale
                      ? _buildOptions(question)
                      : _buildTextInput(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptions(Question question) {
    final colors = [
      const Color(0xFFF4EEFF),
      const Color(0xFFEAF4FF),
      const Color(0xFFE8FFF4),
      const Color(0xFFFFF7D6),
    ];

    return ListView.builder(
      itemCount: question.options.length,
      itemBuilder: (context, index) {
        final option = question.options[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: AnswerCard(
            text: option.label, // Restored original .label pattern
            color: colors[index % colors.length],
            onTap: () {
              // Pass the option label text down to the controller map
              controller.answerQuestion(option.label);
            },
          ),
        );
      },
    );
  }

  Widget _buildTextInput() {
    final controllerText = TextEditingController();

    return Column(
      children: [
        TextField(
          controller: controllerText,
          maxLines: 6,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintText: "Tell us more...",
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF23C4C8),
              padding: const EdgeInsets.all(18),
            ),
            onPressed: () {
              if (controllerText.text.trim().isNotEmpty) {
                controller.answerQuestion(controllerText.text.trim());
              }
            },
            child: const Text("Continue"),
          ),
        )
      ],
    );
  }
}