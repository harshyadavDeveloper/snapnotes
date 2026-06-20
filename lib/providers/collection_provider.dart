import 'package:snapnotes/core/state/base_notifier.dart';
import 'package:snapnotes/providers/dashboard_notifier.dart';

import '../data/models/collection_model.dart';
import '../domain/usecases/collections/create_collection_usecase.dart';
import '../domain/usecases/collections/delete_collection_usecase.dart';
import '../domain/usecases/collections/get_collections_usecase.dart';

class CollectionNotifier extends BaseNotifier {
  final GetCollectionsUseCase _getCollectionsUseCase;
  final CreateCollectionUseCase _createCollectionUseCase;
  final DeleteCollectionUseCase _deleteCollectionUseCase;
  final DashboardNotifier _dashboardNotifier;

  CollectionNotifier(
    this._getCollectionsUseCase,
    this._createCollectionUseCase,
    this._deleteCollectionUseCase,
    this._dashboardNotifier,
  );

  List<CollectionModel> collections = [];

  Future<void> loadCollections() async {
    await execute(() async {
      collections = await _getCollectionsUseCase();

      notifyListeners();
    });
  }

  Future<void> createCollection(String name) async {
    await execute(() async {
      await _createCollectionUseCase(name);
      await _dashboardNotifier.loadDashboard();

      await loadCollections();
    });
  }

  Future<void> deleteCollection(int id) async {
    await execute(() async {
      await _deleteCollectionUseCase(id);
      await _dashboardNotifier.loadDashboard();

      await loadCollections();
    });
  }
}
