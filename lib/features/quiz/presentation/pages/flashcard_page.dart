import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/quiz_service.dart';
import '../../data/models/question_model.dart';

class FlashcardPage extends ConsumerStatefulWidget {
  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends ConsumerState<FlashcardPage> {
  final QuizService _quizService = QuizService();
  bool _showAnswer = false;
  int _currentIndex = 0;
  List<Question> _flashcards = [];

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  void _loadFlashcards() async {
    final flashcards = await _quizService.getQuestions().first;
    setState(() {
      _flashcards = flashcards;
    });
  }

  void _flipFlashcard() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  void _nextFlashcard() {
    if (_currentIndex < _flashcards.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    }
  }

  void _previousFlashcard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showAnswer = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Flashcards'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final flashcard = _flashcards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcards'),
      ),
      body: GestureDetector(
        onTap: _flipFlashcard,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _showAnswer ? "Odpowiedź:" : "Pytanie:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                _showAnswer ? flashcard.correctAnswer : flashcard.question,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          ),
        ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _previousFlashcard,
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _nextFlashcard,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
