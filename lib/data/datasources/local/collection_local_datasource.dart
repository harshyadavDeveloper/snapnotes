import 'package:isar_community/isar.dart';

import '../../../database/isar/isar_service.dart';
import '../../models/collection_model.dart';

class CollectionLocalDataSource {
  Future<List<CollectionModel>> getCollections() async {
    final isar = await IsarService.instance;

    return isar.collectionModels.where().findAll();
  }

  Future<void> createCollection(CollectionModel collection) async {
    final isar = await IsarService.instance;

    await isar.writeTxn(() async {
      await isar.collectionModels.put(collection);
    });
  }

  Future<void> deleteCollection(int id) async {
    final isar = await IsarService.instance;

    await isar.writeTxn(() async {
      await isar.collectionModels.delete(id);
    });
  }
}
