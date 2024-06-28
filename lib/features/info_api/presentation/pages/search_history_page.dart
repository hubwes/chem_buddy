import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_history_provider.dart';
import '../../data/models/search_history_model.dart';
import '../../../../l10n/app_localizations.dart';

class SearchHistoryPage extends ConsumerWidget {
  final Function(String) onSearch;

  SearchHistoryPage({required this.onSearch});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchHistoryStream = ref.watch(searchHistoryProvider);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('search_history')),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: searchHistoryStream.when(
          data: (historyList) {
            if (historyList.isEmpty) {
              return Center(child: Text('No search history found'));
            }
            return ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final history = historyList[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      history.compoundName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      history.timestamp.toString(),
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Colors.deepOrange,
                    ),
                    onTap: () {
                      onSearch(history.compoundName);
                    },
                  ),
                );
              },
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}
