import '../../repositories/collection_repository.dart';

class GetTotalCollectionsUseCase {
  GetTotalCollectionsUseCase(this._repository);
  final CollectionRepository _repository;

  Future<int> call() async {
    final collections = await _repository.getCollections();

    return collections.length;
  }
}
