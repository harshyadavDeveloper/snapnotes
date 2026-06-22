import 'package:snapnotes/core/state/base_notifier.dart';
import 'package:snapnotes/domain/usecases/notes/get_note_by_id_usecase.dart';
import 'package:snapnotes/domain/usecases/notes/toggle_favorite_usecase.dart';
import 'package:snapnotes/domain/usecases/notes/update_note_usecase.dart';
import 'package:snapnotes/providers/dashboard_notifier.dart';

import '../data/models/note_model.dart';
import '../domain/usecases/notes/create_note_usecase.dart';
import '../domain/usecases/notes/delete_note_usecase.dart';
import '../domain/usecases/notes/get_notes_by_collection_usecase.dart';
import '../domain/usecases/notes/get_notes_usecase.dart';

class NoteNotifier extends BaseNotifier {
  final GetNotesUseCase _getNotesUseCase;
  final GetNotesByCollectionUseCase _getNotesByCollectionUseCase;
  final CreateNoteUseCase _createNoteUseCase;
  final DeleteNoteUseCase _deleteNoteUseCase;
  final DashboardNotifier _dashboardNotifier;
  final UpdateNoteUseCase _updateNoteUseCase;
  final GetNoteByIdUseCase _getNoteByIdUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;

  NoteNotifier(
    this._getNotesUseCase,
    this._getNotesByCollectionUseCase,
    this._createNoteUseCase,
    this._deleteNoteUseCase,
    this._dashboardNotifier,
    this._updateNoteUseCase,
    this._getNoteByIdUseCase,
    this._toggleFavoriteUseCase,
  );

  List<NoteModel> notes = [];

  int? selectedCollectionId;

  List<NoteModel> get favoriteNotes =>
      notes.where((note) => note.isFavorite).toList();

  Future<void> loadNotes() async {
    await execute(() async {
      notes = await _getNotesUseCase();

      notifyListeners();
    });
  }

  Future<void> loadNotesByCollection(int collectionId) async {
    selectedCollectionId = collectionId;

    await execute(() async {
      notes = await _getNotesByCollectionUseCase(collectionId);

      notifyListeners();
    });
  }

  Future<void> createNote({
    required String title,
    required String content,
    required int collectionId,
    List<String> tags = const [],
  }) async {
    await execute(() async {
      await _createNoteUseCase(
        title: title,
        content: content,
        collectionId: collectionId,
        tags: tags,
      );
      await _dashboardNotifier.loadDashboard();

      if (selectedCollectionId != null) {
        await loadNotesByCollection(selectedCollectionId!);
      } else {
        await loadNotes();
      }
    });
  }

  Future<void> deleteNote(int id) async {
    await execute(() async {
      await _deleteNoteUseCase(id);
      await _dashboardNotifier.loadDashboard();

      if (selectedCollectionId != null) {
        await loadNotesByCollection(selectedCollectionId!);
      } else {
        await loadNotes();
      }
    });
  }

  Future<void> updateNote(NoteModel note) async {
    await execute(() async {
      await _updateNoteUseCase(note);

      await _dashboardNotifier.loadDashboard();

      await loadNotes();
    });
  }

  Future<NoteModel?> getNoteById(int id) async {
    try {
      return await _getNoteByIdUseCase(id);
    } catch (e) {
      setError(e.toString());

      return null;
    }
  }

  Future<void> toggleFavorite(NoteModel note) async {
    await execute(() async {
      await _toggleFavoriteUseCase(note);

      await _dashboardNotifier.loadDashboard();

      await loadNotes();
    });
  }

  void clearNotes() {
    notes.clear();
    selectedCollectionId = null;
    notifyListeners();
  }
}
