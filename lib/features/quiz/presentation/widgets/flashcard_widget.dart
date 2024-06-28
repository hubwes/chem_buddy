import 'package:flutter/material.dart';
import '../../domain/entities/flashcard.dart';

class FlashcardWidget extends StatelessWidget {
  final Flashcard flashcard;
  final VoidCallback onFlip;

  FlashcardWidget({required this.flashcard, required this.onFlip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFlip,
      child: Card(
        child: Center(
          child: Text(
            flashcard.question,
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
