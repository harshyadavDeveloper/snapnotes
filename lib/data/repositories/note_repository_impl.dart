import '../../domain/repositories/note_repository.dart';
import '../datasources/local/note_local_datasource.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  NoteRepositoryImpl(this._localDatasource);
  final NoteLocalDataSource _localDatasource;

  @override
  Future<List<NoteModel>> getNotes() {
    return _localDatasource.getNotes();
  }

  @override
  Future<List<NoteModel>> getNotesByCollection(int collectionId) {
    return _localDatasource.getNotesByCollection(collectionId);
  }

  @override
  Future<void> createNote(NoteModel note) {
    return _localDatasource.createNote(note);
  }

  @override
  Future<void> deleteNote(int id) {
    return _localDatasource.deleteNote(id);
  }

  @override
  Future<void> updateNote(NoteModel note) {
    return _localDatasource.updateNote(note);
  }

  @override
  Future<NoteModel?> getNoteById(int id) {
    return _localDatasource.getNoteById(id);
  }
}
