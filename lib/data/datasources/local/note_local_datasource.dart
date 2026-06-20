import 'package:isar_community/isar.dart';

import '../../../database/isar/isar_service.dart';
import '../../models/note_model.dart';

class NoteLocalDataSource {
  Future<List<NoteModel>> getNotes() async {
    final isar = await IsarService.instance;

    return isar.noteModels.where().findAll();
  }

  Future<List<NoteModel>> getNotesByCollection(int collectionId) async {
    final isar = await IsarService.instance;

    return isar.noteModels.filter().collectionIdEqualTo(collectionId).findAll();
  }

  Future<void> createNote(NoteModel note) async {
    final isar = await IsarService.instance;

    await isar.writeTxn(() async {
      await isar.noteModels.put(note);
    });
  }

  Future<void> deleteNote(int id) async {
    final isar = await IsarService.instance;

    await isar.writeTxn(() async {
      await isar.noteModels.delete(id);
    });
  }
}
