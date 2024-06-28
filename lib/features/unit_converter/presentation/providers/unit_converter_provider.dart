import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnitConverterState {
  final List<String> unitTypes;
  final String selectedUnitType;
  final String selectedFromUnit;
  final String selectedToUnit;
  final double valueToConvert;
  final double? convertedValue;
  final Map<String, List<String>> units;

  UnitConverterState({
    required this.unitTypes,
    required this.selectedUnitType,
    required this.selectedFromUnit,
    required this.selectedToUnit,
    required this.valueToConvert,
    required this.convertedValue,
    required this.units,
  });

  UnitConverterState copyWith({
    List<String>? unitTypes,
    String? selectedUnitType,
    String? selectedFromUnit,
    String? selectedToUnit,
    double? valueToConvert,
    double? convertedValue,
    Map<String, List<String>>? units,
  }) {
    return UnitConverterState(
      unitTypes: unitTypes ?? this.unitTypes,
      selectedUnitType: selectedUnitType ?? this.selectedUnitType,
      selectedFromUnit: selectedFromUnit ?? this.selectedFromUnit,
      selectedToUnit: selectedToUnit ?? this.selectedToUnit,
      valueToConvert: valueToConvert ?? this.valueToConvert,
      convertedValue: convertedValue ?? this.convertedValue,
      units: units ?? this.units,
    );
  }
}

class UnitConverterNotifier extends StateNotifier<UnitConverterState> {
  UnitConverterNotifier()
      : super(
    UnitConverterState(
      unitTypes: ['Length', 'Mass', 'Volume'],
      selectedUnitType: 'Length',
      selectedFromUnit: 'Meter',
      selectedToUnit: 'Kilometer',
      valueToConvert: 0,
      convertedValue: null,
      units: {
        'Length': ['Meter', 'Kilometer', 'Centimeter'],
        'Mass': ['Gram', 'Kilogram', 'Milligram'],
        'Volume': ['Liter', 'Milliliter', 'Cubic meter'],
      },
    ),
  );

  void selectUnitType(String unitType) {
    state = state.copyWith(
      selectedUnitType: unitType,
      selectedFromUnit: state.units[unitType]!.first,
      selectedToUnit: state.units[unitType]!.first,
      convertedValue: null,
    );
  }

  void selectFromUnit(String fromUnit) {
    state = state.copyWith(
      selectedFromUnit: fromUnit,
      convertedValue: null,
    );
  }

  void selectToUnit(String toUnit) {
    state = state.copyWith(
      selectedToUnit: toUnit,
      convertedValue: null,
    );
  }

  void setValueToConvert(double value) {
    state = state.copyWith(
      valueToConvert: value,
    );
  }

  void convert() {
    double convertedValue = 0;

    if (state.selectedUnitType == 'Length') {
      convertedValue = _convertLength(state.valueToConvert, state.selectedFromUnit, state.selectedToUnit);
    } else if (state.selectedUnitType == 'Mass') {
      convertedValue = _convertMass(state.valueToConvert, state.selectedFromUnit, state.selectedToUnit);
    } else if (state.selectedUnitType == 'Volume') {
      convertedValue = _convertVolume(state.valueToConvert, state.selectedFromUnit, state.selectedToUnit);
    }

    state = state.copyWith(convertedValue: convertedValue);
  }

  double _convertLength(double value, String fromUnit, String toUnit) {
    const conversionRates = {
      'Meter': 1.0,
      'Kilometer': 1000.0,
      'Centimeter': 0.01,
    };

    final baseValue = value * conversionRates[fromUnit]!;
    final convertedValue = baseValue / conversionRates[toUnit]!;
    return convertedValue;
  }

  double _convertMass(double value, String fromUnit, String toUnit) {
    const conversionRates = {
      'Gram': 1.0,
      'Kilogram': 1000.0,
      'Milligram': 0.001,
    };

    final baseValue = value * conversionRates[fromUnit]!;
    final convertedValue = baseValue / conversionRates[toUnit]!;
    return convertedValue;
  }

  double _convertVolume(double value, String fromUnit, String toUnit) {
    const conversionRates = {
      'Liter': 1.0,
      'Milliliter': 0.001,
      'Cubic meter': 1000.0,
    };

    final baseValue = value * conversionRates[fromUnit]!;
    final convertedValue = baseValue / conversionRates[toUnit]!;
    return convertedValue;
  }
}
