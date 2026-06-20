import 'package:snapnotes/core/state/base_notifier.dart';

import '../domain/usecases/dashboard/get_total_collections_usecase.dart';
import '../domain/usecases/dashboard/get_total_notes_usecase.dart';

class DashboardNotifier extends BaseNotifier {
  final GetTotalNotesUseCase _getTotalNotesUseCase;

  final GetTotalCollectionsUseCase _getTotalCollectionsUseCase;

  DashboardNotifier(
    this._getTotalNotesUseCase,
    this._getTotalCollectionsUseCase,
  );

  int totalNotes = 0;

  int totalCollections = 0;

  Future<void> loadDashboard() async {
    await execute(() async {
      totalNotes = await _getTotalNotesUseCase();

      totalCollections = await _getTotalCollectionsUseCase();

      notifyListeners();
    });
  }
}
