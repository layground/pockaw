import 'package:pockaw/core/utils/logger.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<ShareResultStatus> shareFiles(List<XFile> files) async {
    final params = ShareParams(text: 'Great picture', files: files);

    final result = await SharePlus.instance.share(params);

    Log.d(result.status, label: 'share');

    return result.status;
  }

  static Future<void> shareLogFile() async {
    final file = await Log.getLogFile();
    Log.d(file?.path, label: 'share', logToFile: false);

    if (file != null) {
      final status = await shareFiles([XFile(file.path)]);
      if (status == ShareResultStatus.success) {
        Log.d('successful', label: 'share', logToFile: false);
      }
    }
  }
}
