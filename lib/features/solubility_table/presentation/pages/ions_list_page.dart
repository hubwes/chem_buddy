import 'package:flutter/material.dart';
import '../../data/repositories/ions.dart';

class IonsListPage extends StatelessWidget {
  const IonsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ions List'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cations',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cationReactions.keys.length,
                      itemBuilder: (context, index) {
                        final ion = cationReactions.keys.elementAt(index);
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
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: anionReactions.keys.length,
                      itemBuilder: (context, index) {
                        final ion = anionReactions.keys.elementAt(index);
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
              children: [
                ...reactions.map((reaction) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(reaction),
                )),
              ],
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
