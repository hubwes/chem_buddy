import 'package:cloud_firestore/cloud_firestore.dart';

class SearchHistory {
  final String compoundName;
  final DateTime timestamp;

  SearchHistory({required this.compoundName, required this.timestamp});

  Map<String, dynamic> toJson() {
    return {
      'compoundName': compoundName,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
      compoundName: json['compoundName'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }
}
