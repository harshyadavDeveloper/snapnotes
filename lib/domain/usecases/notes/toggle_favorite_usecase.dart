import '../../../data/models/note_model.dart';
import '../../repositories/note_repository.dart';

class ToggleFavoriteUseCase {
  final NoteRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  Future<void> call(NoteModel note) async {
    note.isFavorite = !note.isFavorite;

    note.updatedAt = DateTime.now();

    await _repository.updateNote(note);
  }
}
