import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chem_buddy/features/periodic_table/domain/entities/element.dart';
import 'package:chem_buddy/features/periodic_table/presentation/providers/element_notifier.dart';
import 'package:chem_buddy/features/mass_calculator/utils/formula_parser.dart';

class MassCalculatorPage extends ConsumerStatefulWidget {
  @override
  _MassCalculatorPageState createState() => _MassCalculatorPageState();
}

class _MassCalculatorPageState extends ConsumerState<MassCalculatorPage> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _formulaController = TextEditingController();
  double? _result;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final elementsState = ref.watch(elementNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mass Calculator'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: elementsState.when(
          data: (elements) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity (moles)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _formulaController,
                  decoration: InputDecoration(
                    labelText: 'Chemical Formula',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _calculateMass(elements),
                    child: Text('Calculate Mass'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (_result != null)
                  Text(
                    'Mass: $_result g',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                if (_error != null)
                  Text(
                    'Error: $_error',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
              ],
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  void _calculateMass(List<ChemElement> elements) {
    setState(() {
      _error = null;
      _result = null;
    });

    if (_quantityController.text.isEmpty || _formulaController.text.isEmpty) {
      setState(() {
        _error = 'Please enter both quantity and formula';
      });
      return;
    }

    final quantity = double.tryParse(_quantityController.text);
    if (quantity == null) {
      setState(() {
        _error = 'Invalid quantity';
      });
      return;
    }

    try {
      final parser = FormulaParser(elements);
      final molarMass = parser.calculateMolarMass(_formulaController.text);
      setState(() {
        _result = quantity * molarMass;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }
}
