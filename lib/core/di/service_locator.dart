import 'package:get_it/get_it.dart';

import '../../data/datasources/local/collection_local_datasource.dart';
import '../../data/repositories/collection_repository_impl.dart';
import '../../domain/repositories/collection_repository.dart';
import '../../domain/usecases/collections/create_collection_usecase.dart';
import '../../domain/usecases/collections/delete_collection_usecase.dart';
import '../../domain/usecases/collections/get_collections_usecase.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerLazySingleton(() => CollectionLocalDataSource());

  getIt.registerLazySingleton<CollectionRepository>(
    () => CollectionRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton(() => GetCollectionsUseCase(getIt()));

  getIt.registerLazySingleton(() => CreateCollectionUseCase(getIt()));

  getIt.registerLazySingleton(() => DeleteCollectionUseCase(getIt()));
}
