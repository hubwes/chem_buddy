import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/question_model.dart';
import '../../services/quiz_service.dart';

class QuestionForm extends StatefulWidget {
  final Question? question;
  final Function onSave;

  QuestionForm({this.question, required this.onSave});

  @override
  _QuestionFormState createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _optionsController = List.generate(4, (_) => TextEditingController());
  final _correctAnswerController = TextEditingController();
  final _quizService = QuizService();

  @override
  void initState() {
    super.initState();
    if (widget.question != null) {
      _questionController.text = widget.question!.question;
      for (int i = 0; i < widget.question!.options.length; i++) {
        _optionsController[i].text = widget.question!.options[i];
      }
      _correctAnswerController.text = widget.question!.correctAnswer;
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _optionsController.forEach((controller) => controller.dispose());
    _correctAnswerController.dispose();
    super.dispose();
  }

  void _saveQuestion() {
    if (_formKey.currentState!.validate()) {
      final newQuestion = Question(
        id: widget.question?.id ?? Uuid().v4(),
        question: _questionController.text,
        options: _optionsController.map((controller) => controller.text).toList(),
        correctAnswer: _correctAnswerController.text,
      );

      widget.onSave(newQuestion);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.question != null ? 'Edit Question' : 'Add Question'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(labelText: 'Question'),
                validator: (value) => value!.isEmpty ? 'Please enter a question' : null,
              ),
              ..._optionsController.asMap().entries.map((entry) {
                return TextFormField(
                  controller: entry.value,
                  decoration: InputDecoration(labelText: 'Option ${entry.key + 1}'),
                  validator: (value) => value!.isEmpty ? 'Please enter an option' : null,
                );
              }).toList(),
              TextFormField(
                controller: _correctAnswerController,
                decoration: InputDecoration(labelText: 'Correct Answer'),
                validator: (value) => value!.isEmpty ? 'Please enter the correct answer' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: _saveQuestion,
          child: Text('Save'),
        ),
      ],
    );
  }
}
