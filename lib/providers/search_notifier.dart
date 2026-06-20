import 'dart:async';

import 'package:snapnotes/core/state/base_notifier.dart';

import '../data/models/note_model.dart';
import '../domain/usecases/search/search_notes_usecase.dart';

class SearchNotifier extends BaseNotifier {
  final SearchNotesUseCase _searchNotesUseCase;
  Timer? _debounce;

  SearchNotifier(this._searchNotesUseCase);

  String query = '';

  List<NoteModel> results = [];

  void search(String value) {
    query = value;

    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      await execute(() async {
        results = await _searchNotesUseCase(value);

        notifyListeners();
      });
    });

    notifyListeners();
  }

  void clear() {
    _debounce?.cancel();

    query = '';

    results.clear();

    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();

    super.dispose();
  }
}
