import 'package:get_it/get_it.dart';
import 'package:snapnotes/core/services/pdf_service.dart';
import 'package:snapnotes/data/datasources/local/note_local_datasource.dart';
import 'package:snapnotes/data/repositories/note_repository_impl.dart';
import 'package:snapnotes/domain/repositories/note_repository.dart';
import 'package:snapnotes/domain/usecases/dashboard/get_recent_notes_usecase.dart';
import 'package:snapnotes/domain/usecases/dashboard/get_total_collections_usecase.dart';
import 'package:snapnotes/domain/usecases/dashboard/get_total_notes_usecase.dart';
import 'package:snapnotes/domain/usecases/notes/create_note_usecase.dart';
import 'package:snapnotes/domain/usecases/notes/delete_note_usecase.dart';
import 'package:snapnotes/domain/usecases/notes/get_note_by_id_usecase.dart';
import 'package:snapnotes/domain/usecases/notes/get_notes_by_collection_usecase.dart';
import 'package:snapnotes/domain/usecases/notes/get_notes_usecase.dart';
import 'package:snapnotes/domain/usecases/notes/toggle_favorite_usecase.dart';
import 'package:snapnotes/domain/usecases/notes/update_note_usecase.dart';
import 'package:snapnotes/domain/usecases/search/search_notes_usecase.dart';

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

  // DataSource
  getIt.registerLazySingleton(() => NoteLocalDataSource());

  // Repository
  getIt.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(getIt()),
  );

  // UseCases
  getIt.registerLazySingleton(() => GetNotesUseCase(getIt()));

  getIt.registerLazySingleton(() => GetNotesByCollectionUseCase(getIt()));

  getIt.registerLazySingleton(() => CreateNoteUseCase(getIt()));

  getIt.registerLazySingleton(() => DeleteNoteUseCase(getIt()));

  getIt.registerLazySingleton(() => GetTotalNotesUseCase(getIt()));

  getIt.registerLazySingleton(() => GetTotalCollectionsUseCase(getIt()));

  getIt.registerLazySingleton(() => GetRecentNotesUseCase(getIt()));

  getIt.registerLazySingleton(() => SearchNotesUseCase(getIt()));

  getIt.registerLazySingleton(() => UpdateNoteUseCase(getIt()));

  getIt.registerLazySingleton(() => GetNoteByIdUseCase(getIt()));

  getIt.registerLazySingleton(() => ToggleFavoriteUseCase(getIt()));

  getIt.registerLazySingleton(() => PdfService());
}
