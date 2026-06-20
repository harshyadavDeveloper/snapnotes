import '../../../data/models/collection_model.dart';
import '../../repositories/collection_repository.dart';

class CreateCollectionUseCase {
  final CollectionRepository _repository;

  CreateCollectionUseCase(this._repository);

  Future<void> call(String name) async {
    final collection = CollectionModel()
      ..name = name
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    await _repository.createCollection(collection);
  }
}
