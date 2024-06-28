import 'package:hive/hive.dart';
import 'package:fl_chart/fl_chart.dart';
part 'note.g.dart';

@HiveType(typeId: 1)
class Note {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String? textContent;
  @HiveField(3)
  final List<Map<String, double>>? dataPoints;
  @HiveField(4)
  final NoteType type;

  Note({
    required this.id,
    required this.title,
    this.textContent,
    this.dataPoints,
    required this.type,
  });

  Note copyWith({
    String? id,
    String? title,
    String? textContent,
    List<Map<String, double>>? dataPoints,
    NoteType? type,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      textContent: textContent ?? this.textContent,
      dataPoints: dataPoints ?? this.dataPoints,
      type: type ?? this.type,
    );
  }

  static List<Map<String, double>> convertFlSpotList(List<FlSpot> flSpotList) {
    return flSpotList.map((flSpot) => {'x': flSpot.x, 'y': flSpot.y}).toList();
  }

  static List<FlSpot> convertMapListToFlSpotList(List<Map<String, double>> mapList) {
    return mapList.map((map) => FlSpot(map['x']!, map['y']!)).toList();
  }

  bool get hasGraphData => dataPoints != null && dataPoints!.isNotEmpty;
}

@HiveType(typeId: 2)
enum NoteType {
  @HiveField(0)
  text,
  @HiveField(1)
  graph,
}
