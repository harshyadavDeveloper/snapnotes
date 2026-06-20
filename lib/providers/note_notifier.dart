import 'package:snapnotes/core/state/base_notifier.dart';

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

  NoteNotifier(
    this._getNotesUseCase,
    this._getNotesByCollectionUseCase,
    this._createNoteUseCase,
    this._deleteNoteUseCase,
  );

  List<NoteModel> notes = [];

  int? selectedCollectionId;

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

      if (selectedCollectionId != null) {
        await loadNotesByCollection(selectedCollectionId!);
      } else {
        await loadNotes();
      }
    });
  }

  void clearNotes() {
    notes.clear();
    selectedCollectionId = null;
    notifyListeners();
  }
}
