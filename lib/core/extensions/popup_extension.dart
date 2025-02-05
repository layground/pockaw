import 'package:pockaw/core/components/custom_keyboard/custom_keyboard.dart';
import 'package:flutter/material.dart';

extension PopupExtension on BuildContext {
  void openBottomSheet(Widget child, {double? height}) {
    showModalBottomSheet(
      context: this,
      builder: (context) => SizedBox(
        height: height ?? MediaQuery.of(context).size.height * 0.4,
        child: child,
      ),
    );
  }

  void openBottomSheetNoBarrier(
    Widget child, {
    double? height,
    Color backgroundColor = Colors.white,
  }) {
    showModalBottomSheet(
      context: this,
      barrierColor: Colors.transparent,
      backgroundColor: backgroundColor,
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
