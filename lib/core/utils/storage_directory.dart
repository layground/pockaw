import 'dart:io';

import 'package:path_provider/path_provider.dart';

class TemporaryStorageDirectory {
  static Future<Directory?> getDirectory() async {
    Directory? dir;
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      dir = await getApplicationDocumentsDirectory();
    } else {
      dir = await getTemporaryDirectory();
    }
    return dir;
  }
}
