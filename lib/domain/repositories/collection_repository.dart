import '../../data/models/collection_model.dart';

abstract class CollectionRepository {
  Future<List<CollectionModel>> getCollections();

  Future<void> createCollection(CollectionModel collection);

  Future<void> deleteCollection(int id);
}
