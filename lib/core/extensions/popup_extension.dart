import 'package:pockaw/core/components/custom_keyboard/custom_keyboard.dart';
import 'package:flutter/material.dart';

extension PopupExtension on BuildContext {
  Future<T?> openBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet(
      context: this,
      showDragHandle: true,
      isScrollControlled: isScrollControlled,
      builder: (context) => child,
    );
  }

  Future<T?> openBottomSheetNoBarrier<T>(
    Widget child, {
    double? height,
    Color backgroundColor = Colors.white,
  }) {
    return showModalBottomSheet(
      context: this,
      barrierColor: Colors.transparent,
      backgroundColor: backgroundColor,
      showDragHandle: true,
      builder: (context) => SizedBox(
        height: height ?? MediaQuery.of(context).size.height * 0.4,
        child: child,
      ),
    );
  }

  void openCustomKeyboard(TextEditingController controller, {int? maxLength}) {
    showModalBottomSheet(
      context: this,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.grey.shade100,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: CustomKeyboard(controller: controller),
      ),
    );
  }
}
