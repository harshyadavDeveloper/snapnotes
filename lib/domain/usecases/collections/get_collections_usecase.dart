import '../../../data/models/collection_model.dart';
import '../../repositories/collection_repository.dart';

class GetCollectionsUseCase {
  GetCollectionsUseCase(this._repository);
  final CollectionRepository _repository;

  Future<List<CollectionModel>> call() {
    return _repository.getCollections();
  }
}
