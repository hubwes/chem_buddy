import 'package:flutter/material.dart';
import 'package:chem_buddy/features/chemical_reaction_calculator/utils/chemical_reaction_calculator.dart';

class ChemicalReactionCalculatorPage extends StatefulWidget {
  @override
  _ChemicalReactionCalculatorPageState createState() => _ChemicalReactionCalculatorPageState();
}

class _ChemicalReactionCalculatorPageState extends State<ChemicalReactionCalculatorPage> {
  final TextEditingController _equationController = TextEditingController();
  String? _result;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chemical Reaction Calculator'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chemical Equation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _equationController,
              decoration: InputDecoration(
                hintText: 'e.g., H2 + O2 -> H2O',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculateReaction,
                child: Text('Calculate Reaction'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_result != null)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Result: $_result',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            if (_error != null)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error: $_error',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _calculateReaction() {
    setState(() {
      _error = null;
      _result = null;
    });

    final equation = _equationController.text;

    if (equation.isEmpty) {
      setState(() {
        _error = 'Please enter a chemical equation';
      });
      return;
    }

    try {
      final calculator = ChemicalReactionCalculator();
      final balancedEquation = calculator.balanceEquation(equation);
      final result = calculator.calculateMoles(
        balancedEquation,
      );

      setState(() {
        _result = result;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }
}
