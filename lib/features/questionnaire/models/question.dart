/// The type of input a [Question] expects from the user.
enum QuestionType { scale, text }

/// A single selectable option for a [QuestionType.scale] question.
class QuestionOption {
  final String label;
  final int value;

  const QuestionOption({required this.label, required this.value});
}

/// Decides which question id comes next, given the answer to the
/// current question. Returning `null` signals the end of the flow.
typedef NextQuestionResolver = String? Function(dynamic answer);

/// A single node in the questionnaire graph.
///
/// The branching logic lives entirely in [resolveNext], which keeps
/// navigation rules co-located with the question they apply to instead
/// of scattered through the UI layer.
class Question {
  final String id;
  final String prompt;
  final QuestionType type;
  final List<QuestionOption> options;
  final NextQuestionResolver resolveNext;

  const Question({
    required this.id,
    required this.prompt,
    required this.type,
    this.options = const [],
    required this.resolveNext,
  });
}