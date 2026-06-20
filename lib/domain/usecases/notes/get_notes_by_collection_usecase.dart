import '../../../data/models/note_model.dart';
import '../../repositories/note_repository.dart';

class GetNotesByCollectionUseCase {
  final NoteRepository _repository;

  GetNotesByCollectionUseCase(this._repository);

  Future<List<NoteModel>> call(int collectionId) {
    return _repository.getNotesByCollection(collectionId);
  }
}
