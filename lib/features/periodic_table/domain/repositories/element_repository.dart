import 'package:dartz/dartz.dart';
import 'package:chem_buddy/core/error/failures.dart';
import '../entities/element.dart';

abstract class ElementRepository {
  Future<Either<Failure, List<ChemElement>>> getElements();
}
