import '../../../data/models/note_model.dart';
import '../../repositories/note_repository.dart';

class GetNoteByIdUseCase {
  GetNoteByIdUseCase(this._repository);
  final NoteRepository _repository;

  Future<NoteModel?> call(int id) {
    return _repository.getNoteById(id);
  }
}
