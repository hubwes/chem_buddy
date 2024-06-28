// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compound_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Compound _$CompoundFromJson(Map<String, dynamic> json) => Compound(
      molecularFormula: json['molecularFormula'] as String,
      molecularWeight: json['molecularWeight'] as String,
      canonicalSMILES: json['canonicalSMILES'] as String,
      iupacName: json['iupacName'] as String?,
      inchi: json['inchi'] as String?,
      inchiKey: json['inchiKey'] as String?,
      xlogp3: (json['xlogp3'] as num?)?.toDouble(),
      exactMass: json['exactMass'] as String?,
      topologicalPolarSurfaceArea:
          (json['topologicalPolarSurfaceArea'] as num?)?.toDouble(),
      complexity: (json['complexity'] as num?)?.toDouble(),
      hydrogenBondDonorCount: (json['hydrogenBondDonorCount'] as num?)?.toInt(),
      hydrogenBondAcceptorCount:
          (json['hydrogenBondAcceptorCount'] as num?)?.toInt(),
      rotatableBondCount: (json['rotatableBondCount'] as num?)?.toInt(),
      monoIsotopicWeight: (json['monoIsotopicWeight'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CompoundToJson(Compound instance) => <String, dynamic>{
      'molecularFormula': instance.molecularFormula,
      'molecularWeight': instance.molecularWeight,
      'canonicalSMILES': instance.canonicalSMILES,
      'iupacName': instance.iupacName,
      'inchi': instance.inchi,
      'inchiKey': instance.inchiKey,
      'xlogp3': instance.xlogp3,
      'exactMass': instance.exactMass,
      'topologicalPolarSurfaceArea': instance.topologicalPolarSurfaceArea,
      'complexity': instance.complexity,
      'hydrogenBondDonorCount': instance.hydrogenBondDonorCount,
      'hydrogenBondAcceptorCount': instance.hydrogenBondAcceptorCount,
      'rotatableBondCount': instance.rotatableBondCount,
      'monoIsotopicWeight': instance.monoIsotopicWeight,
    };
