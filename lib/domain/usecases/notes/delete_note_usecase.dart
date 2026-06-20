import '../../repositories/note_repository.dart';

class DeleteNoteUseCase {
  final NoteRepository _repository;

  DeleteNoteUseCase(this._repository);

  Future<void> call(int id) {
    return _repository.deleteNote(id);
  }
}
