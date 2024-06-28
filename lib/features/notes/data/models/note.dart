import 'package:fl_chart/fl_chart.dart';

class Note {
  final String id;
  final List<FlSpot> dataPoints;

  Note({
    required this.id,
    required this.dataPoints,
  });

  Note copyWith({
    String? id,
    List<FlSpot>? dataPoints,
  }) {
    return Note(
      id: id ?? this.id,
      dataPoints: dataPoints ?? this.dataPoints,
    );
  }
}
