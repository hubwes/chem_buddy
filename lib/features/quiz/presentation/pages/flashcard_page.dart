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
          backgroundColor: Colors.deepOrange,
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
        backgroundColor: Colors.deepOrange,
      ),
      body: GestureDetector(
        onTap: _flipFlashcard,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.deepOrange),
                onPressed: _previousFlashcard,
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward, color: Colors.deepOrange),
                onPressed: _nextFlashcard,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
