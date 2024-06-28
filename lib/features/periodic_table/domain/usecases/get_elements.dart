import 'package:dartz/dartz.dart';
import 'package:chem_buddy/core/error/failures.dart';
import '../entities/element.dart';
import '../repositories/element_repository.dart';

class GetElements {
  final ElementRepository repository;

  GetElements(this.repository);

  Future<Either<Failure, List<ChemElement>>> call() async {
    return await repository.getElements();
  }
}
