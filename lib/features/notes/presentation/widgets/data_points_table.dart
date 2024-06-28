import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DataPointsTable extends StatelessWidget {
  final List<FlSpot> dataPoints;

  DataPointsTable({required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: [
          DataColumn(label: Text('X')),
          DataColumn(label: Text('Y')),
        ],
        rows: dataPoints.map((point) {
          return DataRow(cells: [
            DataCell(Text(point.x.toString())),
            DataCell(Text(point.y.toString())),
          ]);
        }).toList()
    );
  }
}
