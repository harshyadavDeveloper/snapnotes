import '../../repositories/note_repository.dart';

class DeleteNoteUseCase {
  DeleteNoteUseCase(this._repository);
  final NoteRepository _repository;

  Future<void> call(int id) {
    return _repository.deleteNote(id);
  }
}
