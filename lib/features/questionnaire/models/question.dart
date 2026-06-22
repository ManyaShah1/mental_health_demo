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
    var parsedOptions = <QuestionOption>[];

    if (json['options'] != null) {
      final rawOptions = json['options'] as List<dynamic>;

      for (int i = 0; i < rawOptions.length; i++) {
        final element = rawOptions[i];
        if (element is String) {
          // Converts plain backend strings into the old option objects
          parsedOptions.add(QuestionOption(label: element, value: i));
        } else if (element is Map<String, dynamic>) {
          parsedOptions.add(QuestionOption.fromJson(element));
        }
      }
    }

    return Question(
      id: json['id'] as String? ?? '',
      prompt: json['question'] as String? ?? json['prompt'] as String? ?? '',
      type: (json['type'] as String? ?? 'scale').toLowerCase() == 'text'
          ? QuestionType.text
          : QuestionType.scale,
      options: parsedOptions,
      resolveNext: (answer) => null,
    );
  }
}