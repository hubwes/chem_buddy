import 'package:flutter/material.dart';
import 'package:chem_buddy/features/periodic_table/domain/entities/element.dart';

class ElementDetailPage extends StatelessWidget {
  final ChemElement element;

  ElementDetailPage({required this.element});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(element.name),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: theme.cardColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    element.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.orangeAccent : Colors.deepOrange,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                _buildDetailRow('Symbol', element.symbol, isDarkMode),
                _buildDetailRow('Atomic Mass', element.atomicMass.toString(), isDarkMode),
                _buildDetailRow('Category', element.category, isDarkMode),
                _buildDetailRow('Density', element.density.toString(), isDarkMode),
                _buildDetailRow('Discovered By', element.discoveredBy, isDarkMode),
                SizedBox(height: 10),
                Text(
                  'Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.orangeAccent : Colors.deepOrange,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  element.summary,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.orangeAccent : Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20,
                color: isDarkMode ? Colors.white70 : Colors.black54,

              ),
              textAlign:  TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
