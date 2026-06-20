import '../../repositories/collection_repository.dart';

class DeleteCollectionUseCase {
  final CollectionRepository _repository;

  DeleteCollectionUseCase(this._repository);

  Future<void> call(int id) {
    return _repository.deleteCollection(id);
  }
}
