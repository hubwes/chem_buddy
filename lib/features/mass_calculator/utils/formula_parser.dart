import 'package:chem_buddy/features/periodic_table/domain/entities/element.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormulaParser {
  final Map<String, ChemElement> elementMap;

  FormulaParser(List<ChemElement> elements)
      : elementMap = {for (var e in elements) e.symbol: e};

  double calculateMolarMass(String formula) {
    final parsedElements = _parseFormula(formula);
    double molarMass = 0.0;

    parsedElements.forEach((symbol, count) {
      final element = elementMap[symbol];
      if (element != null) {
        molarMass += element.atomicMass * count;
      } else {
        throw Exception('Unknown element: $symbol');
      }
    });

    return molarMass;
  }

  Map<String, int> _parseFormula(String formula) {
    final regex = RegExp(r'([A-Z][a-z]*)(\d*)|(\()|(\))(\d*)|(\[)|(\])(\d*)');
    final matches = regex.allMatches(formula);
    final stack = <Map<String, int>>[];
    var currentMap = <String, int>{};

    void addToCurrentMap(String symbol, int count) {
      currentMap[symbol] = (currentMap[symbol] ?? 0) + count;
    }

    for (var match in matches) {
      if (match.group(1) != null) {
        final symbol = match.group(1)!;
        final count = int.tryParse(match.group(2)!) ?? 1;
        addToCurrentMap(symbol, count);
      } else if (match.group(3) != null) {
        stack.add(currentMap);
        currentMap = <String, int>{};
      } else if (match.group(4) != null) {
        final groupCount = int.tryParse(match.group(5)!) ?? 1;
        final topMap = stack.removeLast();
        currentMap.forEach((symbol, count) {
          topMap[symbol] = (topMap[symbol] ?? 0) + count * groupCount;
        });
        currentMap = topMap;
      } else if (match.group(6) != null) {
        stack.add(currentMap);
        currentMap = <String, int>{};
      } else if (match.group(7) != null) {
        final groupCount = int.tryParse(match.group(8)!) ?? 1;
        final topMap = stack.removeLast();
        currentMap.forEach((symbol, count) {
          topMap[symbol] = (topMap[symbol] ?? 0) + count * groupCount;
        });
        currentMap = topMap;
      }
    }

    return currentMap;
  }
}
