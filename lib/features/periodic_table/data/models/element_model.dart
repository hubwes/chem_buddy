import '../../domain/entities/element.dart';

class ElementModel extends ChemElement {
  ElementModel({
    required int number,
    required String name,
    required String symbol,
    required double atomicMass,
    String? category,
    double? density,
    String? discoveredBy,
    String? summary,
  }) : super(
    number: number,
    name: name,
    symbol: symbol,
    atomicMass: atomicMass,
    category: category ?? 'Unknown', // Provide a default value
    density: density ?? 0.0, // Provide a default value
    discoveredBy: discoveredBy ?? 'Unknown', // Provide a default value
    summary: summary ?? 'No summary available', // Provide a default value
  );

  factory ElementModel.fromJson(Map<String, dynamic> json) {
    return ElementModel(
      number: json['number'] as int,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      atomicMass: (json['atomic_mass'] as num).toDouble(),
      category: json['category'] as String?,
      density: (json['density'] as num?)?.toDouble(),
      discoveredBy: json['discovered_by'] as String?,
      summary: json['summary'] as String?,
    );
  }
}
