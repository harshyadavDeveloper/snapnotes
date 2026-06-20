import '../../../data/models/collection_model.dart';
import '../../repositories/collection_repository.dart';

class GetCollectionsUseCase {
  final CollectionRepository _repository;

  GetCollectionsUseCase(this._repository);

  Future<List<CollectionModel>> call() {
    return _repository.getCollections();
  }
}
