import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/quiz_service.dart';
import '../widgets/question_form.dart';
import '../../data/models/question_model.dart';

class QuestionListPage extends ConsumerWidget {
  final QuizService _quizService = QuizService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questions'),
        backgroundColor: Colors.deepOrange,
      ),
      body: StreamBuilder<List<Question>>(
        stream: _quizService.getQuestions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No questions available.'));
          }

          final questions = snapshot.data!;

          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: ListTile(
                  title: Text(
                    question.question,
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    'Options: ${question.options.join(', ')}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.deepOrange),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return QuestionForm(
                                question: question,
                                onSave: (updatedQuestion) {
                                  _quizService.updateQuestion(updatedQuestion);
                                },
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _quizService.deleteQuestion(question.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return QuestionForm(
                onSave: (newQuestion) {
                  _quizService.addQuestion(newQuestion);
                },
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}
