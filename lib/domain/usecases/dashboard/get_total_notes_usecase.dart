import '../../repositories/note_repository.dart';

class GetTotalNotesUseCase {
  final NoteRepository _repository;

  GetTotalNotesUseCase(this._repository);

  Future<int> call() async {
    final notes = await _repository.getNotes();

    return notes.length;
  }
}
