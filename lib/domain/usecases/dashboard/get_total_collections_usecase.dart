import '../../repositories/collection_repository.dart';

class GetTotalCollectionsUseCase {
  final CollectionRepository _repository;

  GetTotalCollectionsUseCase(this._repository);

  Future<int> call() async {
    final collections = await _repository.getCollections();

    return collections.length;
  }
}
