import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chem_buddy/features/periodic_table/presentation/providers/element_notifier.dart';
import 'package:chem_buddy/features/periodic_table/presentation/pages/element_detail_page.dart';
import 'package:chem_buddy/features/periodic_table/presentation/widgets/element_card.dart';
import 'package:chem_buddy/core/error/failures.dart';
import '../../domain/entities/element.dart';

class PeriodicTablePage extends ConsumerStatefulWidget {
  @override
  _PeriodicTablePageState createState() => _PeriodicTablePageState();
}

class _PeriodicTablePageState extends ConsumerState<PeriodicTablePage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elementsState = ref.watch(elementNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Periodic Table'),
        backgroundColor: Colors.deepOrange,
      ),
      body: elementsState.when(
        data: (elements) {
          elements.sort((a, b) => a.number.compareTo(b.number));
          return buildPeriodicTable(elements, context);
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          String errorMessage;
          if (error is Failure) {
            errorMessage = error.message;
          } else {
            errorMessage = 'An unexpected error occurred';
          }
          return Center(child: Text('Error: $errorMessage'));
        },
      ),
    );
  }

  Widget buildPeriodicTable(List<ChemElement> elements, BuildContext context) {
    final elementMap = {for (var e in elements) e.number: e};

    final tableStructure = [
      [1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 2],
      [3, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 5, 6, 7, 8, 9, 10],
      [11, 12, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 13, 14, 15, 16, 17, 18],
      [19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36],
      [37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54],
      [55, 56, -1, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86],
      [87, 88, -1, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118],
      [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
      [-1, -1, -1, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71],
      [-1, -1, -1, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103]
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 18,
            childAspectRatio: 1.0,
          ),
          itemCount: tableStructure.length * 18,
          itemBuilder: (context, index) {
            final row = index ~/ 18;
            final col = index % 18;
            final atomicNumber = tableStructure[row][col];

            if (atomicNumber == -1) {
              return Container();
            } else if (elementMap.containsKey(atomicNumber)) {
              final element = elementMap[atomicNumber]!;
              return ElementCard(
                element: element,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ElementDetailPage(element: element),
                    ),
                  );
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class ElementCard extends StatelessWidget {
  final ChemElement element;
  final VoidCallback onTap;

  ElementCard({required this.element, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.deepOrangeAccent.withOpacity(0.7),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                element.symbol,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                element.number.toString(),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
