import 'package:flutter/material.dart';
import '../../data/repositories/ions.dart';

class IonsListWidget extends StatelessWidget {
  const IonsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cations',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.deepOrange),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cations.length,
                    itemBuilder: (context, index) {
                      final ion = cations.elementAt(index);
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          title: Text(
                            ion,
                            style: TextStyle(fontSize: 18),
                          ),
                          onTap: () {
                            _showReactions(context, ion, 'Cation', cationReactions[ion]!);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Anions',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.deepOrange),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: anions.length,
                    itemBuilder: (context, index) {
                      final ion = anions.elementAt(index);
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          title: Text(
                            ion,
                            style: TextStyle(fontSize: 18),
                          ),
                          onTap: () {
                            _showReactions(context, ion, 'Anion', anionReactions[ion]!);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReactions(BuildContext context, String ion, String type, List<String> reactions) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$type Reactions for $ion'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: reactions.map((reaction) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(reaction),
              )).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
