import '../../../data/models/note_model.dart';
import '../../repositories/note_repository.dart';

class CreateNoteUseCase {
  CreateNoteUseCase(this._repository);
  final NoteRepository _repository;

  Future<void> call({
    required String title,
    required String content,
    required int collectionId,
    List<String> tags = const [],
  }) async {
    final note = NoteModel()
      ..title = title
      ..content = content
      ..collectionId = collectionId
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now()
      ..tags = tags;

    await _repository.createNote(note);
  }
}
