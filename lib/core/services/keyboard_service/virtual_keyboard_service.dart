import 'package:flutter/widgets.dart';

/// A utility class for managing keyboard interactions.
class KeyboardService {
  /// Private constructor to prevent instantiation.
  KeyboardService._();

  /// Closes the on-screen keyboard if it is open.
  static void closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
