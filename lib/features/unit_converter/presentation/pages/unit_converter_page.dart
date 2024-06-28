import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/unit_converter_provider.dart';

final unitConverterProvider = StateNotifierProvider<UnitConverterNotifier, UnitConverterState>(
      (ref) => UnitConverterNotifier(),
);

class UnitConverterPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(unitConverterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Unit Converter'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Unit Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: state.selectedUnitType,
              onChanged: (value) {
                ref.read(unitConverterProvider.notifier).selectUnitType(value!);
              },
              items: state.unitTypes.map((String unitType) {
                return DropdownMenuItem<String>(
                  value: unitType,
                  child: Text(unitType),
                );
              }).toList(),
              isExpanded: true,
            ),
            SizedBox(height: 16),
            Text(
              'Value to Convert',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter value',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                ref.read(unitConverterProvider.notifier).setValueToConvert(double.tryParse(value) ?? 0);
              },
            ),
            SizedBox(height: 16),
            Text(
              'From Unit',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: state.selectedFromUnit,
              onChanged: (value) {
                ref.read(unitConverterProvider.notifier).selectFromUnit(value!);
              },
              items: state.units[state.selectedUnitType]!.map((String unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              isExpanded: true,
            ),
            SizedBox(height: 16),
            Text(
              'To Unit',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: state.selectedToUnit,
              onChanged: (value) {
                ref.read(unitConverterProvider.notifier).selectToUnit(value!);
              },
              items: state.units[state.selectedUnitType]!.map((String unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              isExpanded: true,
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(unitConverterProvider.notifier).convert();
                },
                child: Text('Convert'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            SizedBox(height: 16),
            if (state.convertedValue != null)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Converted Value: ${state.convertedValue}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
