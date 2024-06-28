import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/question_model.dart';

class QuizService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addQuestion(Question question) async {
    await _firestore.collection('quiz_questions').doc(question.id).set(question.toJson());
  }

  Future<void> updateQuestion(Question question) async {
    await _firestore.collection('quiz_questions').doc(question.id).update(question.toJson());
  }

  Future<void> deleteQuestion(String id) async {
    await _firestore.collection('quiz_questions').doc(id).delete();
  }

  Stream<List<Question>> getQuestions() {
    return _firestore.collection('quiz_questions').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Question.fromJson(doc.data())).toList();
    });
  }
}
