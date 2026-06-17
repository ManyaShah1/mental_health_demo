import 'package:flutter/material.dart';

import '../controllers/questionnaire_controller.dart';
import '../models/question.dart';
import 'result_screen.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() =>
      _QuestionnaireScreenState();
}

class _QuestionnaireScreenState
    extends State<QuestionnaireScreen> {
  final controller = QuestionnaireController();

  @override
  Widget build(BuildContext context) {
    if (controller.isFinished) {
      return ResultScreen(
        answers: controller.answers,
      );
    }

    final question = controller.currentQuestion;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Mental Wellness Check",
          style: TextStyle(
            color: Color(0xff4F46E5),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Container(
              height: 8,

              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.4,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(
                      0xff8B5CF6,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(24),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xffEEF2FF),
                    Color(0xffF5F3FF),
                  ],
                ),

                borderRadius:
                    BorderRadius.circular(24),
              ),

              child: Text(
                question.prompt,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff1E293B),
                ),
              ),
            ),

            const SizedBox(height: 32),

            Expanded(
              child:
                  question.type ==
                          QuestionType.scale
                      ? _buildOptions(
                          question,
                        )
                      : _buildTextInput(
                          question,
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptions(
    Question question,
  ) {
    return ListView.builder(
      itemCount: question.options.length,

      itemBuilder: (context, index) {
        final option =
            question.options[index];

        final colors = [
          const Color(0xffA78BFA),
          const Color(0xff60A5FA),
          const Color(0xff34D399),
          const Color(0xffFBBF24),
        ];

        return Padding(
          padding:
              const EdgeInsets.only(
            bottom: 16,
          ),

          child: InkWell(
            borderRadius:
                BorderRadius.circular(20),

            onTap: () {
              setState(() {
                controller.answerQuestion(
                  option.value,
                );
              });
            },

            child: Container(
              padding:
                  const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color:
                    colors[index %
                        colors.length],

                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),

              child: Text(
                option.label,

                style: const TextStyle(
                  color: Colors.white,
                  fontWeight:
                      FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextInput(
    Question question,
  ) {
    final textController =
        TextEditingController();

    return Column(
      children: [
        TextField(
          controller: textController,

          maxLines: 6,

          decoration: InputDecoration(
            hintText:
                "Tell us how you've been feeling...",

            filled: true,
            fillColor:
                const Color(0xffF8FAFC),

            border:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,

          child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(
                0xff8B5CF6,
              ),

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  16,
                ),
              ),

              padding:
                  const EdgeInsets.all(
                18,
              ),
            ),

            onPressed: () {
              setState(() {
                controller.answerQuestion(
                  textController.text,
                );
              });
            },

            child: const Text(
              "Continue",
            ),
          ),
        ),
      ],
    );
  }
}