import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/questionnaire_service.dart';

class QuestionnaireController extends ChangeNotifier {
  final QuestionnaireService _service = QuestionnaireService();
  final Map<String, dynamic> answers = {};

  Question? _currentQuestion;
  bool _isFinished = false;
  bool _isLoading = false;

  Question? get currentQuestion => _currentQuestion;
  bool get isFinished => _isFinished;
  bool get isLoading => _isLoading;

  Future<void> initializeQuestionnaire() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _service.getNextQuestion(answers);
      _handleBackendResponse(data);
    } catch (e) {
      print("Error initializing assessment: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> answerQuestion(dynamic selectedOption) async {
    if (_currentQuestion == null) return;

    _isLoading = true;
    notifyListeners();
    try {
      answers[_currentQuestion!.id] = selectedOption;
      final data = await _service.getNextQuestion(answers);
      _handleBackendResponse(data);
    } catch (e) {
      print("Error updating question sequence: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
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