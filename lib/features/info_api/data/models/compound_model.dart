import 'package:json_annotation/json_annotation.dart';

part 'compound_model.g.dart';

@JsonSerializable()
class Compound {
  final String molecularFormula;
  final String molecularWeight;
  final String canonicalSMILES;
  final String? iupacName;
  final String? inchi;
  final String? inchiKey;
  final double? xlogp3;
  final String? exactMass;
  final double? topologicalPolarSurfaceArea;
  final double? complexity;
  final int? hydrogenBondDonorCount;
  final int? hydrogenBondAcceptorCount;
  final int? rotatableBondCount;
  final double? monoIsotopicWeight;

  Compound({
    required this.molecularFormula,
    required this.molecularWeight,
    required this.canonicalSMILES,
    this.iupacName,
    this.inchi,
    this.inchiKey,
    this.xlogp3,
    this.exactMass,
    this.topologicalPolarSurfaceArea,
    this.complexity,
    this.hydrogenBondDonorCount,
    this.hydrogenBondAcceptorCount,
    this.rotatableBondCount,
    this.monoIsotopicWeight,
  });

  factory Compound.fromJson(Map<String, dynamic> json) {
    final props = json['props'] as List<dynamic>;

    String? getStringValue(String label, [String? name]) {
      final prop = props.firstWhere(
              (prop) =>
          prop['urn']['label'] == label &&
              (name == null || prop['urn']['name'] == name),
          orElse: () => null);
      return prop?['value']['sval'];
    }

    double? getDoubleValue(String label, [String? name]) {
      final prop = props.firstWhere(
              (prop) =>
          prop['urn']['label'] == label &&
              (name == null || prop['urn']['name'] == name),
          orElse: () => null);
      final value = prop?['value']['fval'] ?? prop?['value']['ival'];
      return value != null ? value.toDouble() : null;
    }

    int? getIntValue(String label, [String? name]) {
      final prop = props.firstWhere(
              (prop) =>
          prop['urn']['label'] == label &&
              (name == null || prop['urn']['name'] == name),
          orElse: () => null);
      return prop?['value']['ival'];
    }

    return Compound(
      molecularFormula:
      getStringValue('Molecular Formula') ?? 'N/A',
      molecularWeight:
      getStringValue('Molecular Weight') ?? 'N/A',
      canonicalSMILES:
      getStringValue('SMILES', 'Canonical') ?? 'N/A',
      iupacName: getStringValue('IUPAC Name', 'Preferred'),
      inchi: getStringValue('InChI'),
      inchiKey: getStringValue('InChIKey'),
      xlogp3: getDoubleValue('Log P', 'XLogP3'),
      exactMass: getStringValue('Mass', 'Exact') ?? 'N/A',
      topologicalPolarSurfaceArea:
      getDoubleValue('Topological', 'Polar Surface Area'),
      complexity: getDoubleValue('Compound Complexity'),
      hydrogenBondDonorCount: getIntValue('Count', 'Hydrogen Bond Donor'),
      hydrogenBondAcceptorCount: getIntValue('Count', 'Hydrogen Bond Acceptor'),
      rotatableBondCount: getIntValue('Count', 'Rotatable Bond'),
      monoIsotopicWeight: getDoubleValue('Weight', 'MonoIsotopic'),
    );
  }

  Map<String, dynamic> toJson() => _$CompoundToJson(this);
}
