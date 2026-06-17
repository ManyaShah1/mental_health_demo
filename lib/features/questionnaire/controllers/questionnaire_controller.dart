import '../data/questionnaire_data.dart';
import '../models/question.dart';

class QuestionnaireController {
  final Map<String, dynamic> answers = {};

  String currentQuestionId =
      QuestionnaireData.rootId;

  Question get currentQuestion =>
      QuestionnaireData.graph[currentQuestionId]!;

  bool get isFinished =>
      currentQuestionId.isEmpty;

  void answerQuestion(dynamic answer) {
    answers[currentQuestionId] = answer;

    final nextQuestion =
        currentQuestion.resolveNext(answer);

    if (nextQuestion == null) {
      currentQuestionId = '';
      return;
    }

    currentQuestionId = nextQuestion;
  }
}