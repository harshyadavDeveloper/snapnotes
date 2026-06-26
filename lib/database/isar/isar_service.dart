import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/models/collection_model.dart';
import '../../data/models/note_model.dart';
import '../../data/models/scan_model.dart';
import '../../data/models/settings_model.dart';

class IsarService {
  IsarService._();

  static Isar? _isar;

  static Future<Isar> get instance async {
    if (_isar != null) return _isar!;

    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open([
      CollectionModelSchema,
      NoteModelSchema,
      ScanModelSchema,
      SettingsModelSchema,
    ], directory: dir.path);

    return _isar!;
  }
}
