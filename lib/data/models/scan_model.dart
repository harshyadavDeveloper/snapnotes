
import 'package:isar_community/isar.dart';

part 'scan_model.g.dart';

@collection
class ScanModel {
  Id id = Isar.autoIncrement;

  late String imagePath;

  late int noteId;

  late DateTime createdAt;
}