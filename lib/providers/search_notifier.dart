import 'package:snapnotes/core/state/base_notifier.dart';

import '../data/models/note_model.dart';
import '../domain/usecases/search/search_notes_usecase.dart';

class SearchNotifier extends BaseNotifier {
  final SearchNotesUseCase _searchNotesUseCase;

  SearchNotifier(this._searchNotesUseCase);

  String query = '';

  List<NoteModel> results = [];

  Future<void> search(String value) async {
    query = value;

    await execute(() async {
      results = await _searchNotesUseCase(value);

      notifyListeners();
    });
  }

  void clear() {
    query = '';
    results.clear();

    notifyListeners();
  }
}
