import 'dart:math';

class ChemicalReactionCalculator {
  String balanceEquation(String equation) {
    final sides = equation.split('->');
    if (sides.length != 2) {
      throw Exception('Invalid equation format');
    }

    final reactants = _parseCompounds(sides[0]);
    final products = _parseCompounds(sides[1]);

    final allElements = {...reactants.expand((c) => c.keys), ...products.expand((c) => c.keys)}.toList();

    final elementMatrix = _buildElementMatrix(reactants, products, allElements);
    final coefficients = _solveMatrixFractional(elementMatrix);

    if (coefficients == null) {
      throw Exception('Unable to balance equation');
    }

    final balancedEquation = _buildBalancedEquation(reactants, products, coefficients);
    return balancedEquation;
  }

  List<Map<String, int>> _parseCompounds(String side) {
    final compounds = side.split('+');
    final compoundList = <Map<String, int>>[];

    for (final compound in compounds) {
      compoundList.add(_parseCompound(compound.trim()));
    }

    return compoundList;
  }

  Map<String, int> _parseCompound(String compound) {
    final regex = RegExp(r'([A-Z][a-z]*)(\d*)');
    final matches = regex.allMatches(compound);
    final elementMap = <String, int>{};

    for (final match in matches) {
      final element = match.group(1)!;
      final count = int.tryParse(match.group(2)!) ?? 1;
      elementMap[element] = count;
    }

    return elementMap;
  }

  List<List<double>> _buildElementMatrix(List<Map<String, int>> reactants, List<Map<String, int>> products, List<String> allElements) {
    final matrix = <List<double>>[];

    for (final element in allElements) {
      final row = <double>[];

      for (final reactant in reactants) {
        row.add((reactant[element] ?? 0).toDouble());
      }

      for (final product in products) {
        row.add(-(product[element] ?? 0).toDouble());
      }

      matrix.add(row);
    }

    return matrix;
  }

  List<double>? _solveMatrixFractional(List<List<double>> matrix) {
    final numRows = matrix.length;
    final numCols = matrix[0].length;

    final augmentedMatrix = List.generate(numRows, (i) => List<double>.from(matrix[i])..add(0.0));

    for (var i = 0; i < numRows; i++) {
      var maxRow = i;
      for (var k = i + 1; k < numRows; k++) {
        if (augmentedMatrix[k][i].abs() > augmentedMatrix[maxRow][i].abs()) {
          maxRow = k;
        }
      }

      if (augmentedMatrix[i][i] == 0) {
        return null;
      }

      final temp = augmentedMatrix[maxRow];
      augmentedMatrix[maxRow] = augmentedMatrix[i];
      augmentedMatrix[i] = temp;

      for (var k = i + 1; k < numRows; k++) {
        final factor = augmentedMatrix[k][i] / augmentedMatrix[i][i];
        for (var j = i; j < numCols + 1; j++) {
          augmentedMatrix[k][j] -= factor * augmentedMatrix[i][j];
        }
      }
    }

    final coefficients = List.filled(numCols, 1.0);
    for (var i = numRows - 1; i >= 0; i--) {
      var sum = 0.0;
      for (var j = i + 1; j < numCols; j++) {
        sum += augmentedMatrix[i][j] * coefficients[j];
      }
      coefficients[i] = (augmentedMatrix[i][numCols] - sum) / augmentedMatrix[i][i];
    }

    return _normalizeCoefficients(coefficients);
  }

  List<double> _normalizeCoefficients(List<double> coefficients) {
    final lcm = coefficients.map((c) => c.denominator).reduce((a, b) => _lcm(a, b));
    return coefficients.map((c) => c * lcm).toList();
  }

  int _gcd(int a, int b) {
    while (b != 0) {
      final t = b;
      b = a % b;
      a = t;
    }
    return a.abs();
  }

  int _lcm(int a, int b) {
    return (a * b) ~/ _gcd(a, b);
  }

  String _buildBalancedEquation(List<Map<String, int>> reactants, List<Map<String, int>> products, List<double> coefficients) {
    final reactantCoefficients = coefficients.sublist(0, reactants.length);
    final productCoefficients = coefficients.sublist(reactants.length);

    final balancedReactants = reactants.asMap().entries.map((entry) {
      final coeff = reactantCoefficients[entry.key];
      final compound = _compoundToString(entry.value);
      return (coeff > 1 ? '${coeff.toInt()} ' : '') + compound;
    }).join(' + ');

    final balancedProducts = products.asMap().entries.map((entry) {
      final coeff = productCoefficients[entry.key];
      final compound = _compoundToString(entry.value);
      return (coeff > 1 ? '${coeff.toInt()} ' : '') + compound;
    }).join(' + ');

    return '$balancedReactants -> $balancedProducts';
  }

  String _compoundToString(Map<String, int> compound) {
    return compound.entries.map((e) => e.value > 1 ? '${e.key}${e.value}' : e.key).join();
  }

  String calculateMoles(String balancedEquation, {double? moles, double? yieldPercentage}) {
    final sides = balancedEquation.split(' -> ');
    final reactants = _parseCompounds(sides[0]);
    final products = _parseCompounds(sides[1]);

    if (moles == null) {
      return balancedEquation;
    }

    final limitingReactant = reactants.expand((c) => c.values).reduce(min);
    final moleRatio = moles / limitingReactant;

    final yieldFactor = yieldPercentage != null ? yieldPercentage / 100.0 : 1.0;

    final reactantMoles = reactants.map((elements) => elements.values.reduce(min) * moleRatio * yieldFactor).toList();
    final productMoles = products.map((elements) => elements.values.reduce(min) * moleRatio * yieldFactor).toList();

    final result = StringBuffer();
    result.writeln('Balanced Equation: $balancedEquation');
    result.writeln('Reactant Moles:');
    for (int i = 0; i < reactants.length; i++) {
      result.writeln('${_compoundToString(reactants[i])}: ${reactantMoles[i].toStringAsFixed(2)}');
    }
    result.writeln('Product Moles:');
    for (int i = 0; i < products.length; i++) {
      result.writeln('${_compoundToString(products[i])}: ${productMoles[i].toStringAsFixed(2)}');
    }

    return result.toString();
  }
}

extension Rational on double {
  int get numerator => (this * denominator).round();
  int get denominator => _findDenominator(this);

  int _findDenominator(double value, [int precision = 1]) {
    final gcd = _gcd(value, precision.toDouble());
    return (precision / gcd).toInt();
  }

  double _gcd(double a, double b) {
    while (b != 0) {
      final t = b;
      b = a % b;
      a = t;
    }
    return a.abs();
  }
}
