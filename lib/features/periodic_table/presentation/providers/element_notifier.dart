import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/element.dart';
import '../../domain/usecases/get_elements.dart';
import 'package:chem_buddy/core/error/failures.dart';
import 'package:chem_buddy/injection_container.dart'; // Import GetIt instance

final elementNotifierProvider = StateNotifierProvider<ElementNotifier, AsyncValue<List<ChemElement>>>(
      (ref) => ElementNotifier(getElements: ref.watch(getElementsProvider)),
);

final getElementsProvider = Provider<GetElements>((ref) {
  return sl<GetElements>();
});

class ElementNotifier extends StateNotifier<AsyncValue<List<ChemElement>>> {
  final GetElements getElements;

  ElementNotifier({required this.getElements}) : super(AsyncLoading()) {
    _fetchElements();
  }

  Future<void> _fetchElements() async {
    final elementsOrFailure = await getElements();
    elementsOrFailure.fold(
          (failure) => state = AsyncError(failure, StackTrace.current),
          (elements) => state = AsyncData(elements),
    );
  }
}
