import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoProvider extends ChangeNotifier {
  String version = '';

  Future<void> load() async {
    final info = await PackageInfo.fromPlatform();

    version = '${info.version}+${info.buildNumber}';

    notifyListeners();
  }
}