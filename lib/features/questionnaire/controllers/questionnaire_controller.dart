import '../models/question.dart';
import '../services/questionnaire_service.dart';

class QuestionnaireController {
  final QuestionnaireService _service = QuestionnaireService();
  
  // Tracks your exact session history: {"mood_1": "Several days"}
  final Map<String, dynamic> answers = {};

  Question? _currentQuestion;
  bool _isFinished = false;
  bool _isLoading = false;

  Question? get currentQuestion => _currentQuestion;
  bool get isFinished => _isFinished;
  bool get isLoading => _isLoading;

  /// Call this when the Questionnaire screen loads (e.g. inside initState)
  Future<void> initializeQuestionnaire() async {
    _isLoading = true;
    try {
      final data = await _service.getNextQuestion(answers);
      _handleBackendResponse(data);
    } catch (e) {
      print("Error initializing assessment: $e");
    } finally {
      _isLoading = false;
    }
  }

  /// Call this when the user chooses an option and clicks 'Next'
  Future<void> answerQuestion(dynamic selectedOption) async {
    if (_currentQuestion == null) return;

    _isLoading = true;
    try {
      // 1. Record the response
      answers[_currentQuestion!.id] = selectedOption;

      // 2. Fetch the next step dynamically from the API
      final data = await _service.getNextQuestion(answers);
      _handleBackendResponse(data);
    } catch (e) {
      print("Error updating question sequence: $e");
    } finally {
      _isLoading = false;
    }
  }

  void _handleBackendResponse(Map<String, dynamic> data) {
    if (data['status'] == 'completed') {
      _isFinished = true;
      _currentQuestion = null;
    } else {
      _currentQuestion = Question.fromJson(data);
    }
  }
}