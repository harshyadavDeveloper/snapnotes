import '../../repositories/collection_repository.dart';

class DeleteCollectionUseCase {
  DeleteCollectionUseCase(this._repository);
  final CollectionRepository _repository;

  Future<void> call(int id) {
    return _repository.deleteCollection(id);
  }
}
