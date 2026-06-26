import '../../../data/models/note_model.dart';
import '../../repositories/note_repository.dart';

class ToggleFavoriteUseCase {
  ToggleFavoriteUseCase(this._repository);
  final NoteRepository _repository;

  Future<void> call(NoteModel note) async {
    note.isFavorite = !note.isFavorite;

    note.updatedAt = DateTime.now();

    await _repository.updateNote(note);
  }
}
