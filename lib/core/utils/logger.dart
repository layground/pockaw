import 'dart:developer';

import 'package:flutter/foundation.dart';

class Log {
  static void _console(dynamic message, {String label = 'log'}) {
    if (kDebugMode) {
      String trimmedLabel = label.toLowerCase().replaceAll(' ', '_');
      log('$message', name: trimmedLabel);
    }
  }

  static void d(dynamic message, {String label = 'log'}) {
    if (kDebugMode) {
      _console('$message', label: 'debug_$label');
    }
  }

  static void i(dynamic message, {String label = 'log'}) {
    if (kDebugMode) {
      _console('$message', label: 'info_$label');
    }
  }

  static void e(dynamic message, {String label = 'log'}) {
    if (kDebugMode) {
      _console('$message', label: 'error_$label');
    }
  }
}
