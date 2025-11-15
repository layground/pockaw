import 'dart:io';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:pockaw/core/utils/storage_directory.dart';

class Log {
  static void _console(
    dynamic message, {
    String label = 'log',
    bool logToFile = true,
  }) {
    String trimmedLabel = label.toLowerCase().replaceAll(' ', '_');
    if (kDebugMode) {
      log('$message', name: trimmedLabel);
    }

    if (logToFile) {
      _writeLogToFile('[$trimmedLabel] $message');
    }
  }

  static void d(
    dynamic message, {
    String label = 'log',
    bool logToFile = true,
  }) {
    _console('$message', label: 'debug_$label', logToFile: logToFile);
  }

  static void i(
    dynamic message, {
    String label = 'log',
    bool logToFile = true,
  }) {
    _console('$message', label: 'info_$label', logToFile: logToFile);
  }

  static void e(
    dynamic message, {
    String label = 'log',
    bool logToFile = true,
  }) {
    _console('$message', label: 'error_$label', logToFile: logToFile);
  }

  /// Writes a log message to a file in Downloads (Android) or Documents (iOS).
  /// Returns the file path for reference.
  static Future<void> _writeLogToFile(String message) async {
    final file = await getLogFile();
    if (file != null) {
      final now = DateTime.now().toIso8601String();
      await file.writeAsString('[$now] $message\n', mode: FileMode.append);

      // i(file.path, label: 'log file path', logToFile: false);
    }
  }

  static Future<File?> getLogFile() async {
    final dir = await TemporaryStorageDirectory.getDirectory();
    if (dir == null) return null;
    final file = File('${dir.path}/pockaw_log.txt');
    return file;
  }

  static Future<File?> writeActivityLogFile(String jsonContent) async {
    final dir = await TemporaryStorageDirectory.getDirectory();
    if (dir == null) return null;
    final file = File('${dir.path}/pockaw_activity_log.json');
    await file.writeAsString(jsonContent);
    return file;
  }
}
