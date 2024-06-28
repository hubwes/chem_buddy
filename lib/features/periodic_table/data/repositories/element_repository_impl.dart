import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:chem_buddy/core/error/failures.dart';
import '../../domain/entities/element.dart';
import '../../domain/repositories/element_repository.dart';
import '../datasources/element_remote_data_source.dart';

class ElementRepositoryImpl implements ElementRepository {
  final ElementRemoteDataSource remoteDataSource;

  ElementRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ChemElement>>> getElements() async {
    try {
      final elements = await remoteDataSource.getElements();
      return Right(elements);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Unknown error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
