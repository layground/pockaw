import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pockaw/core/utils/logger.dart';

/// A utility class for managing keyboard interactions.
class KeyboardService {
  /// Private constructor to prevent instantiation.
  KeyboardService._();

  /// Closes the on-screen keyboard if it is open.
  static void closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// Pastes text from the clipboard into the currently focused editable text field.
  static Future<void> pasteFromClipboard(
    TextEditingController textController,
  ) async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    Log.d(clipboardData?.text, label: 'paste from clipboard');
    if (clipboardData?.text == null) return;

    final selection = textController.selection;
    final text = clipboardData!.text!;
    final newText = textController.text.replaceRange(
      selection.start < 0 ? 0 : selection.start,
      selection.end < 0 ? 0 : selection.end,
      text,
    );
    textController.value = textController.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: selection.start + text.length),
    );
  }

  /// Copies the given text to the clipboard.
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    Log.d(text, label: 'copy to clipboard');
  }
}
