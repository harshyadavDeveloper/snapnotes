import '../../repositories/note_repository.dart';

class GetTotalNotesUseCase {
  GetTotalNotesUseCase(this._repository);
  final NoteRepository _repository;

  Future<int> call() async {
    final notes = await _repository.getNotes();

    return notes.length;
  }
}
