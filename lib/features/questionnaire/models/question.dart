/// The type of input a [Question] expects from the user.
enum QuestionType { scale, text }

/// A single selectable option for a [QuestionType.scale] question.
class QuestionOption {
  final String label;
  final int value;

  const QuestionOption({required this.label, required this.value});

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      label: json['label'] as String? ?? json['text'] as String? ?? '',
      value: json['value'] as int? ?? 0,
    );
  }
}

/// Decides which question id comes next, given the answer to the
/// current question. Returning `null` signals the end of the flow.
typedef NextQuestionResolver = String? Function(dynamic answer);

/// A single node in the questionnaire graph driven dynamically by the backend.
class Question {
  final String id;
  final String prompt;
  final QuestionType type;
  final List<QuestionOption> options;
  final NextQuestionResolver? resolveNext;

  const Question({
    required this.id,
    required this.prompt,
    required this.type,
    this.options = const [],
    this.resolveNext,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    // Standard option lists from static keys or simple strings converted safely
    var parsedOptions = <QuestionOption>[];
    if (json['options'] != null) {
      parsedOptions = (json['options'] as List<dynamic>).map((e) {
        if (e is String) {
          return QuestionOption(label: e, value: 0);
        }
        return QuestionOption.fromJson(e as Map<String, dynamic>);
      }).toList();
    }

    return Question(
      id: json['id'] as String,
      prompt: json['question'] as String? ?? json['prompt'] as String? ?? '',
      type: json['type'] == 'text' ? QuestionType.text : QuestionType.scale,
      options: parsedOptions,
      resolveNext: (answer) => null, // Backend manages next paths asynchronously
    );
  }
}