import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConcentrationCalculatorPage extends ConsumerStatefulWidget {
  @override
  _ConcentrationCalculatorPageState createState() => _ConcentrationCalculatorPageState();
}

class _ConcentrationCalculatorPageState extends ConsumerState<ConcentrationCalculatorPage> {
  final TextEditingController _soluteController = TextEditingController();
  final TextEditingController _volumeController = TextEditingController();
  final TextEditingController _molarMassController = TextEditingController();
  final TextEditingController _densityController = TextEditingController(); // Optional density input
  String? _volumeUnit;
  String? _concentrationUnit;
  String? _concentrationType;
  double? _result;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final volumeUnits = ['L', 'mL'];
    final concentrationUnits = _concentrationType == 'Molarity (mol/L)' ? ['M', 'mol/L'] : ['g/L', 'mg/mL'];
    final concentrationTypes = ['Molarity (mol/L)', 'Mass Concentration (g/L)', 'Percentage Concentration'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Concentration Calculator'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              hint: Text('Select Concentration Type'),
              value: _concentrationType,
              onChanged: (String? newValue) {
                setState(() {
                  _concentrationType = newValue;
                  _resetFields();
                });
              },
              items: concentrationTypes.map<DropdownMenuItem<String>>((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              isExpanded: true,
              style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodyMedium?.color),
              dropdownColor: Theme.of(context).colorScheme.background,
            ),
            if (_concentrationType != null) ..._buildInputFields(context),
            SizedBox(height: 20),
            if (_concentrationType != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calculateConcentration,
                  child: Text('Calculate Concentration'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            SizedBox(height: 20),
            if (_result != null)
              Text(
                'Concentration: $_result $_concentrationUnit',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            if (_error != null)
              Text(
                'Error: $_error',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildInputFields(BuildContext context) {
    final volumeUnits = ['L', 'mL'];
    final concentrationUnits = _concentrationType == 'Molarity (mol/L)' ? ['M', 'mol/L'] : ['g/L', 'mg/mL'];

    return [
      TextField(
        controller: _soluteController,
        decoration: InputDecoration(
          labelText: _concentrationType == 'Molarity (mol/L)' ? 'Solute (moles)' : (_concentrationType == 'Percentage Concentration' ? 'Solute (%)' : 'Solute (grams)'),
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodyMedium?.color),
      ),
      SizedBox(height: 20),
      TextField(
        controller: _volumeController,
        decoration: InputDecoration(labelText: 'Volume of Solution', border: OutlineInputBorder()),
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodyMedium?.color),
      ),
      SizedBox(height: 20),
      Text('Select Volume Unit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      DropdownButton<String>(
        hint: Text('Select Volume Unit'),
        value: _volumeUnit,
        onChanged: (String? newValue) {
          setState(() {
            _volumeUnit = newValue;
          });
        },
        items: volumeUnits.map<DropdownMenuItem<String>>((String unit) {
          return DropdownMenuItem<String>(
            value: unit,
            child: Text(unit),
          );
        }).toList(),
        isExpanded: true,
        style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodyMedium?.color),
        dropdownColor: Theme.of(context).colorScheme.background,
      ),
      if (_concentrationType == 'Molarity (mol/L)')
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: TextField(
            controller: _molarMassController,
            decoration: InputDecoration(labelText: 'Molar Mass (g/mol)', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodyMedium?.color),
          ),
        ),
      if (_concentrationType == 'Percentage Concentration')
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: TextField(
            controller: _densityController,
            decoration: InputDecoration(labelText: 'Density (g/mL, optional)', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodyMedium?.color),
          ),
        ),
      SizedBox(height: 20),
      Text('Select Concentration Unit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      DropdownButton<String>(
        hint: Text('Select Concentration Unit'),
        value: _concentrationUnit,
        onChanged: (String? newValue) {
          setState(() {
            _concentrationUnit = newValue;
          });
        },
        items: concentrationUnits.map<DropdownMenuItem<String>>((String unit) {
          return DropdownMenuItem<String>(
            value: unit,
            child: Text(unit),
          );
        }).toList(),
        isExpanded: true,
        style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodyMedium?.color),
        dropdownColor: Theme.of(context).colorScheme.background,
      ),
    ];
  }

  void _resetFields() {
    _soluteController.clear();
    _volumeController.clear();
    _molarMassController.clear();
    _densityController.clear(); // Reset density field
    _volumeUnit = null;
    _concentrationUnit = null;
    _result = null;
    _error = null;
  }

  void _calculateConcentration() {
    setState(() {
      _error = null;
      _result = null;
    });

    if (_soluteController.text.isEmpty || _volumeController.text.isEmpty || _volumeUnit == null || _concentrationUnit == null || _concentrationType == null) {
      setState(() {
        _error = 'Please enter all fields and select units';
      });
      return;
    }

    final solute = double.tryParse(_soluteController.text);
    final volume = double.tryParse(_volumeController.text);
    final molarMass = _concentrationType == 'Molarity (mol/L)' ? double.tryParse(_molarMassController.text) : null;
    final density = _concentrationType == 'Percentage Concentration' ? double.tryParse(_densityController.text) : null;

    if (solute == null || volume == null || (_concentrationType == 'Molarity (mol/L)' && molarMass == null)) {
      setState(() {
        _error = 'Invalid solute, volume or molar mass value';
      });
      return;
    }

    double volumeInLiters = volume;
    if (_volumeUnit == 'mL') {
      volumeInLiters = volume / 1000; // Convert mL to L
    }

    if (_concentrationType == 'Molarity (mol/L)') {
      double moles = solute;
      if (_concentrationUnit == 'g/L' || _concentrationUnit == 'mg/mL') {
        moles = solute / molarMass!;
      }
      setState(() {
        _result = moles / volumeInLiters;
      });
    } else if (_concentrationType == 'Mass Concentration (g/L)') {
      double grams = solute;
      if (_concentrationUnit == 'mg/mL') {
        grams = solute * 1000; // Convert mg to g
      }
      setState(() {
        _result = grams / volumeInLiters;
      });
    } else if (_concentrationType == 'Percentage Concentration') {
      if (density != null) {
        // Convert percentage to g/mL based on density
        double soluteInGrams = solute / 100 * density * volumeInLiters * 1000;
        setState(() {
          _result = soluteInGrams / volumeInLiters;
        });
      } else {
        // Convert percentage to g/L without density
        double soluteInGrams = solute / 100 * volumeInLiters * 1000;
        setState(() {
          _result = soluteInGrams / volumeInLiters;
        });
      }
    }
  }
}
