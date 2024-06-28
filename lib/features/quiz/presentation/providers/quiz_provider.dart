import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/question_service.dart';
import '../../data/models/question_model.dart';

final questionServiceProvider = Provider<QuestionService>((ref) {
  return QuestionService();
});

final questionsProvider = StreamProvider<List<Question>>((ref) {
  final service = ref.watch(questionServiceProvider);
  return service.getQuestions();
});
