import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/compound_model.dart';
import '../../services/chemical_api_service.dart';

final chemicalApiServiceProvider = Provider((ref) => ChemicalApiService());

final compoundProvider = FutureProvider.family<Compound?, String>((ref, compoundName) async {
  final apiService = ref.watch(chemicalApiServiceProvider);
  final data = await apiService.fetchCompoundDetails(compoundName);
  if (data != null) {
    return Compound.fromJson(data);
  } else {
    return null;
  }
});
