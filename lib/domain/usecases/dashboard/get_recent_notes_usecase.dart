import '../../../data/models/note_model.dart';
import '../../repositories/note_repository.dart';

class GetRecentNotesUseCase {
  GetRecentNotesUseCase(this._repository);
  final NoteRepository _repository;

  Future<List<NoteModel>> call() async {
    final notes = await _repository.getNotes();

    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return notes.take(5).toList();
  }
}
