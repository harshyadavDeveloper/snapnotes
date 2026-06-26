import '../../../data/models/note_model.dart';
import '../../repositories/note_repository.dart';

class GetNotesByCollectionUseCase {
  GetNotesByCollectionUseCase(this._repository);
  final NoteRepository _repository;

  Future<List<NoteModel>> call(int collectionId) {
    return _repository.getNotesByCollection(collectionId);
  }
}
