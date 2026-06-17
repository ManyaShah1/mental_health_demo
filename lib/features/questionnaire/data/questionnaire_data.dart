import '../models/question.dart';

/// Static definition of the questionnaire as a directed graph of
/// [Question] nodes. Kept separate from the controller and UI so the
/// clinical content can be reviewed, versioned, or swapped for a
/// remotely-fetched version without touching app logic.
class QuestionnaireData {
  QuestionnaireData._();

  static const String rootId = 'mood';

  static const List<QuestionOption> _frequencyOptions = [
    QuestionOption(label: 'Not at all', value: 0),
    QuestionOption(label: 'Several days', value: 1),
    QuestionOption(label: 'More than half the days', value: 2),
    QuestionOption(label: 'Nearly every day', value: 3),
  ];

  static const Map<String, Question> graph = {
    'mood': Question(
      id: 'mood',
      prompt: 'Over the last 2 weeks, how often have you felt down or hopeless?',
      type: QuestionType.scale,
      options: _frequencyOptions,
      resolveNext: _moodNext,
    ),
    'mood_follow': Question(
      id: 'mood_follow',
      prompt: 'How often have you felt like things are not worth doing?',
      type: QuestionType.scale,
      options: _frequencyOptions,
      resolveNext: _toSleep,
    ),
    'sleep': Question(
      id: 'sleep',
      prompt: 'How often have you had trouble sleeping, or slept too much?',
      type: QuestionType.scale,
      options: _frequencyOptions,
      resolveNext: _sleepNext,
    ),
    'sleep_follow': Question(
      id: 'sleep_follow',
      prompt: 'Has poor sleep affected your concentration during the day?',
      type: QuestionType.scale,
      options: _frequencyOptions,
      resolveNext: _toInterest,
    ),
    'interest': Question(
      id: 'interest',
      prompt:
          'How often have you had little interest or pleasure in things you usually enjoy?',
      type: QuestionType.scale,
      options: _frequencyOptions,
      resolveNext: _interestNext,
    ),
    'interest_follow': Question(
      id: 'interest_follow',
      prompt: 'Have you been avoiding friends or activities you used to enjoy?',
      type: QuestionType.scale,
      options: _frequencyOptions,
      resolveNext: _toFreeText,
    ),
    'free_text': Question(
      id: 'free_text',
      prompt:
          'Anything else about how you have been feeling lately you would like to share?',
      type: QuestionType.text,
      resolveNext: _end,
    ),
  };

  // Each resolver is a static method (not a closure) so the whole
  // graph above can stay a compile-time const map.
  static String? _moodNext(dynamic answer) =>
      (answer as int) >= 2 ? 'mood_follow' : 'sleep';
  static String? _sleepNext(dynamic answer) =>
      (answer as int) >= 2 ? 'sleep_follow' : 'interest';
  static String? _interestNext(dynamic answer) =>
      (answer as int) >= 2 ? 'interest_follow' : 'free_text';

  static String? _toSleep(dynamic _) => 'sleep';
  static String? _toInterest(dynamic _) => 'interest';
  static String? _toFreeText(dynamic _) => 'free_text';
  static String? _end(dynamic _) => null;
}