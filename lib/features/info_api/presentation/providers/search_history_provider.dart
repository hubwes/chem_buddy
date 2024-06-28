import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/search_history_service.dart';
import '../../data/models/search_history_model.dart';

final searchHistoryServiceProvider = Provider((ref) => SearchHistoryService());

final searchHistoryProvider = StreamProvider<List<SearchHistory>>((ref) {
  final searchHistoryService = ref.watch(searchHistoryServiceProvider);
  return searchHistoryService.getSearchHistory();
});
