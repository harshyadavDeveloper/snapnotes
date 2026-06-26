import '../../domain/repositories/collection_repository.dart';
import '../datasources/local/collection_local_datasource.dart';
import '../models/collection_model.dart';

class CollectionRepositoryImpl implements CollectionRepository {
  CollectionRepositoryImpl(this._localDataSource);
  final CollectionLocalDataSource _localDataSource;

  @override
  Future<List<CollectionModel>> getCollections() {
    return _localDataSource.getCollections();
  }

  @override
  Future<void> createCollection(CollectionModel collection) {
    return _localDataSource.createCollection(collection);
  }

  @override
  Future<void> deleteCollection(int id) {
    return _localDataSource.deleteCollection(id);
  }
}
