import '../../data/models/note_model.dart';

abstract class NoteRepository {
  Future<List<NoteModel>> getNotes();

  Future<List<NoteModel>> getNotesByCollection(int collectionId);

  Future<void> createNote(NoteModel note);

  Future<void> deleteNote(int id);
}
