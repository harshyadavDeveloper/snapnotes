import '../../../data/models/collection_model.dart';
import '../../repositories/collection_repository.dart';

class CreateCollectionUseCase {
  CreateCollectionUseCase(this._repository);
  final CollectionRepository _repository;

  Future<void> call(String name) async {
    final collection = CollectionModel()
      ..name = name
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    await _repository.createCollection(collection);
  }
}
