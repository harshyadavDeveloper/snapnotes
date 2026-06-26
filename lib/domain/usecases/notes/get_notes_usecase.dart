import '../../../data/models/note_model.dart';
import '../../repositories/note_repository.dart';

class GetNotesUseCase {
  GetNotesUseCase(this._repository);
  final NoteRepository _repository;

  Future<List<NoteModel>> call() {
    return _repository.getNotes();
  }
}
