import '../../../data/models/note_model.dart';
import '../../repositories/note_repository.dart';

class SearchNotesUseCase {
  SearchNotesUseCase(this._repository);
  final NoteRepository _repository;

  Future<List<NoteModel>> call(String query) async {
    final notes = await _repository.getNotes();

    if (query.trim().isEmpty) {
      return notes;
    }

    final lowerQuery = query.toLowerCase();

    return notes.where((note) {
      return note.title.toLowerCase().contains(lowerQuery) ||
          note.content.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
