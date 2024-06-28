import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/search_history_model.dart';

class SearchHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSearchHistory(String compoundName) async {
    final history = SearchHistory(
      compoundName: compoundName,
      timestamp: DateTime.now(),
    );
    await _firestore.collection('search_history').add(history.toJson());
  }

  Stream<List<SearchHistory>> getSearchHistory() {
    return _firestore.collection('search_history').orderBy('timestamp', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => SearchHistory.fromJson(doc.data())).toList();
    });
  }
}
