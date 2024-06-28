import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'features/periodic_table/data/datasources/element_remote_data_source.dart';
import 'features/periodic_table/data/repositories/element_repository_impl.dart';
import 'features/periodic_table/domain/repositories/element_repository.dart';
import 'features/periodic_table/domain/usecases/get_elements.dart';
import 'features/periodic_table/presentation/providers/element_notifier.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Periodic Table
  // Notifiers
  sl.registerFactory(() => ElementNotifier(getElements: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetElements(sl()));

  // Repository
  sl.registerLazySingleton<ElementRepository>(
        () => ElementRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ElementRemoteDataSource>(
        () => ElementRemoteDataSourceImpl(firestore: sl()),
  );

  // External
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}
