import 'package:isar_community/isar.dart';

part 'settings_model.g.dart';

@collection
class SettingsModel {
  Id id = Isar.autoIncrement;

  bool isDarkMode = false;

  bool isFirstLaunch = true;

  bool syncEnabled = false;
}
