import 'package:flutter/material.dart';
import 'quiz_page.dart';
import 'flashcard_page.dart';
import 'question_list_page.dart';

class MainQuizPage extends StatefulWidget {
  @override
  _MainQuizPageState createState() => _MainQuizPageState();
}

class _MainQuizPageState extends State<MainQuizPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    QuestionListPage(),
    QuizPage(),
    FlashcardPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Questions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on),
            label: 'Flashcards',
          ),
        ],
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
