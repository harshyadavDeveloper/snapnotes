import '../../../data/models/note_model.dart';
import '../../repositories/note_repository.dart';

class UpdateNoteUseCase {
  final NoteRepository _repository;

  UpdateNoteUseCase(this._repository);

  Future<void> call(NoteModel note) {
    note.updatedAt = DateTime.now();

    return _repository.updateNote(note);
  }
}
