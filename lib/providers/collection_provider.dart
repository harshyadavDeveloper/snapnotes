import 'package:flutter/material.dart';

import '../data/models/collection_model.dart';
import '../domain/usecases/collections/create_collection_usecase.dart';
import '../domain/usecases/collections/delete_collection_usecase.dart';
import '../domain/usecases/collections/get_collections_usecase.dart';

class CollectionNotifier extends ChangeNotifier {
  final GetCollectionsUseCase _getCollectionsUseCase;
  final CreateCollectionUseCase _createCollectionUseCase;
  final DeleteCollectionUseCase _deleteCollectionUseCase;

  CollectionNotifier(
    this._getCollectionsUseCase,
    this._createCollectionUseCase,
    this._deleteCollectionUseCase,
  );

  bool isLoading = false;

  String? error;

  List<CollectionModel> collections = [];

  Future<void> loadCollections() async {
    try {
      isLoading = true;
      error = null;

      notifyListeners();

      collections = await _getCollectionsUseCase();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCollection(String name) async {
    try {
      isLoading = true;
      error = null;

      notifyListeners();

      await _createCollectionUseCase(name);

      await loadCollections();
    } catch (e) {
      error = e.toString();

      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> deleteCollection(int id) async {
    try {
      isLoading = true;
      error = null;

      notifyListeners();

      await _deleteCollectionUseCase(id);

      await loadCollections();
    } catch (e) {
      error = e.toString();

      isLoading = false;

      notifyListeners();
    }
  }
}
