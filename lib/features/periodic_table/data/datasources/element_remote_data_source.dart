import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/element_model.dart';

abstract class ElementRemoteDataSource {
  Future<List<ElementModel>> getElements();
}

class ElementRemoteDataSourceImpl implements ElementRemoteDataSource {
  final FirebaseFirestore firestore;

  ElementRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ElementModel>> getElements() async {
    try {
      final snapshot = await firestore.collection('elements').get();
      return snapshot.docs
          .map((doc) => ElementModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        message: 'Error fetching elements: $e',
      );
    }
  }
}
