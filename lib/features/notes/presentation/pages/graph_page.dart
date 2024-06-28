import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import '../widgets/data_points_table.dart';
import '../utils/spline_interpolator.dart';
import '../providers/notes_provider.dart';
import '../../../notes/domain/entities/note.dart';

class GraphPage extends ConsumerStatefulWidget {
  final String? noteId;

  GraphPage({this.noteId});

  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends ConsumerState<GraphPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _xController = TextEditingController();
  final TextEditingController _yController = TextEditingController();
  List<FlSpot> _dataPoints = [];
  bool _showLine = false;
  bool _showTrendLine = false;
  bool _showSpline = false;
  String _trendLineEquation = '';

  @override
  void initState() {
    super.initState();
    if (widget.noteId != null) {
      final note = ref.read(notesProvider.notifier).state.firstWhere((note) => note.id == widget.noteId);
      _titleController.text = note.title;
      _dataPoints = Note.convertMapListToFlSpotList(note.dataPoints ?? []);
    }
  }

  void _addDataPoint() {
    final double? x = double.tryParse(_xController.text);
    final double? y = double.tryParse(_yController.text);
    if (x != null && y != null) {
      setState(() {
        _dataPoints.add(FlSpot(x, y));
        _dataPoints.sort((a, b) => a.x.compareTo(b.x));
      });
      _xController.clear();
      _yController.clear();
    }
  }

  void _saveNote() {
    final title = _titleController.text;
    if (widget.noteId != null) {
      final updatedNote = ref.read(notesProvider.notifier).state.firstWhere((note) => note.id == widget.noteId).copyWith(
        title: title,
        dataPoints: Note.convertFlSpotList(_dataPoints),
      );
      ref.read(notesProvider.notifier).updateNote(updatedNote);
    } else {
      ref.read(notesProvider.notifier).addGraphNote(
        title: title,
        dataPoints: _dataPoints,
      );
    }

    Navigator.pop(context);
  }

  void _toggleTrendLine() {
    setState(() {
      _showTrendLine = !_showTrendLine;
      if (_showTrendLine) {
        _calculateTrendLine();
      } else {
        _trendLineEquation = '';
      }
    });
  }

  void _toggleSpline() {
    setState(() {
      _showSpline = !_showSpline;
    });
  }

  void _calculateTrendLine() {
    if (_dataPoints.length < 2) return;

    final xs = _dataPoints.map((e) => e.x).toList();
    final ys = _dataPoints.map((e) => e.y).toList();

    final n = xs.length;
    final sumX = xs.reduce((a, b) => a + b);
    final sumY = ys.reduce((a, b) => a + b);
    final sumXY = List.generate(n, (i) => xs[i] * ys[i]).reduce((a, b) => a + b);
    final sumXX = List.generate(n, (i) => xs[i] * xs[i]).reduce((a, b) => a + b);

    final slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);
    final intercept = (sumY - slope * sumX) / n;

    setState(() {
      _trendLineEquation = 'y = ${slope.toStringAsFixed(2)}x + ${intercept.toStringAsFixed(2)}';
    });
  }

  LineChartBarData _createTrendLine() {
    if (_dataPoints.length < 2) return LineChartBarData(spots: []);

    final xs = _dataPoints.map((e) => e.x).toList();
    final ys = _dataPoints.map((e) => e.y).toList();

    final n = xs.length;
    final sumX = xs.reduce((a, b) => a + b);
    final sumY = ys.reduce((a, b) => a + b);
    final sumXY = List.generate(n, (i) => xs[i] * ys[i]).reduce((a, b) => a + b);
    final sumXX = List.generate(n, (i) => xs[i] * xs[i]).reduce((a, b) => a + b);

    final slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);
    final intercept = (sumY - slope * sumX) / n;

    final trendSpots = xs.map((x) => FlSpot(x, slope * x + intercept)).toList();

    return LineChartBarData(
      spots: trendSpots,
      isCurved: false,
      barWidth: 2,
      dotData: FlDotData(show: false),
      color: Colors.deepOrange,
    );
  }

  LineChartBarData _createSplineLine() {
    if (_dataPoints.length < 2) return LineChartBarData(spots: []);

    final xs = _dataPoints.map((e) => e.x).toList();
    final ys = _dataPoints.map((e) => e.y).toList();

    final spline = SplineInterpolator(xs, ys);
    final splineSpots = <FlSpot>[];

    for (double x = xs.first; x <= xs.last; x += 0.1) {
      splineSpots.add(FlSpot(x, spline.interpolate(x)));
    }

    return LineChartBarData(
      spots: splineSpots,
      isCurved: true,
      barWidth: 2,
      dotData: FlDotData(show: false),
      color: Colors.green,
    );
  }

  void _calculateEquivalencePoint() {
    if (_dataPoints.length < 2) {
      print('Not enough data points');
      return;
    }

    final xs = _dataPoints.map((e) => e.x).toList();
    final ys = _dataPoints.map((e) => e.y).toList();

    final spline = SplineInterpolator(xs, ys);
    double maxDerivative = double.negativeInfinity;
    double equivalenceX = xs.first;

    for (double x = xs.first; x <= xs.last; x += 0.1) {
      final derivative = spline.derivative(x);
      if (derivative > maxDerivative) {
        maxDerivative = derivative;
        equivalenceX = x;
      }
    }

    final equivalenceY = spline.interpolate(equivalenceX);

    print('Equivalence Point at (x: ${equivalenceX.toStringAsFixed(2)}, y: ${equivalenceY.toStringAsFixed(2)})');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Equivalence Point'),
        content: Text('Equivalence Point at (x: ${equivalenceX.toStringAsFixed(2)}, y: ${equivalenceY.toStringAsFixed(2)})'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trendLine = _showTrendLine ? _createTrendLine() : null;
    final splineLine = _showSpline ? _createSplineLine() : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Graph Drawing'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepOrange),
                ),
                labelStyle: TextStyle(color: Colors.deepOrange),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _xController,
                    decoration: InputDecoration(
                      labelText: 'X Value',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange),
                      ),
                      labelStyle: TextStyle(color: Colors.deepOrange),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _yController,
                    decoration: InputDecoration(
                      labelText: 'Y Value',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange),
                      ),
                      labelStyle: TextStyle(color: Colors.deepOrange),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.deepOrange),
                  onPressed: _addDataPoint,
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _toggleTrendLine,
                  child: Text(_showTrendLine ? 'Hide Trend Line' : 'Show Trend Line'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _toggleSpline,
                  child: Text(_showSpline ? 'Hide Spline' : 'Show Spline'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _calculateEquivalencePoint,
                  child: Text('Equivalence Point'),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (_showTrendLine && _trendLineEquation.isNotEmpty)
              Text(
                'Trend Line: $_trendLineEquation',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: _dataPoints,
                      isCurved: false,
                      barWidth: 2,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                      color: Colors.blue,
                    ),
                    if (_showLine)
                      LineChartBarData(
                        spots: _dataPoints,
                        isCurved: false,
                        barWidth: 2,
                        dotData: FlDotData(show: false),
                      ),
                    if (_showTrendLine && trendLine != null) trendLine,
                    if (_showSpline && splineLine != null) splineLine,
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.black),
                  ),
                  gridData: FlGridData(show: true),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(child: SingleChildScrollView(child: DataPointsTable(dataPoints: _dataPoints))),
          ],
        ),
      ),
    );
  }
}
