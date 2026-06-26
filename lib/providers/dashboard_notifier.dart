import 'package:snapnotes/core/state/base_notifier.dart';
import 'package:snapnotes/data/models/note_model.dart';
import 'package:snapnotes/domain/usecases/dashboard/get_recent_notes_usecase.dart';

import '../domain/usecases/dashboard/get_total_collections_usecase.dart';
import '../domain/usecases/dashboard/get_total_notes_usecase.dart';

class DashboardNotifier extends BaseNotifier {
  DashboardNotifier(
    this._getTotalNotesUseCase,
    this._getTotalCollectionsUseCase,
    this._getRecentNotesUseCase,
  );
  final GetTotalNotesUseCase _getTotalNotesUseCase;

  final GetTotalCollectionsUseCase _getTotalCollectionsUseCase;

  final GetRecentNotesUseCase _getRecentNotesUseCase;

  int totalNotes = 0;

  int totalCollections = 0;

  List<NoteModel> recentNotes = [];

  int totalFavorites = 0;

  Future<void> loadDashboard() async {
    await execute(() async {
      totalNotes = await _getTotalNotesUseCase();

      totalCollections = await _getTotalCollectionsUseCase();

      recentNotes = await _getRecentNotesUseCase();

      totalFavorites = recentNotes.where((note) => note.isFavorite).length;

      notifyListeners();
    });
  }
}
