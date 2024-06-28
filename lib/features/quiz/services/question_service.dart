import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/question_model.dart';

class QuestionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addQuestion(Question question) async {
    await _firestore.collection('questions').add(question.toJson());
  }

  Stream<List<Question>> getQuestions() {
    return _firestore.collection('questions').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Question.fromJson(doc.data() as Map<String, dynamic>)).toList();
    });
  }
}
