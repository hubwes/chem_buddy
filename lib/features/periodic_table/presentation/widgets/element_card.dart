import 'package:flutter/material.dart';
import 'package:chem_buddy/features/periodic_table/domain/entities/element.dart';

class ElementCard extends StatelessWidget {
  final ChemElement element;
  final VoidCallback onTap;

  ElementCard({required this.element, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                element.symbol,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                element.number.toString(),
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
