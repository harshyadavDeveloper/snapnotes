import '../../../data/models/note_model.dart';
import '../../repositories/note_repository.dart';

class GetNotesUseCase {
  final NoteRepository _repository;

  GetNotesUseCase(this._repository);

  Future<List<NoteModel>> call() {
    return _repository.getNotes();
  }
}
