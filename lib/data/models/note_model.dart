
import 'package:isar_community/isar.dart';

part 'note_model.g.dart';

@collection
class NoteModel {
  Id id = Isar.autoIncrement;

  late String title;

  late String content;

  late int collectionId;

  late DateTime createdAt;

  late DateTime updatedAt;

  bool isFavorite = false;

  bool isPinned = false;
}