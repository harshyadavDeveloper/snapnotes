import '../../../data/models/note_model.dart';
import '../../repositories/note_repository.dart';

class GetNoteByIdUseCase {
  final NoteRepository _repository;

  GetNoteByIdUseCase(this._repository);

  Future<NoteModel?> call(int id) {
    return _repository.getNoteById(id);
  }
}
