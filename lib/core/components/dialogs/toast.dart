import 'package:flutter/material.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:toastification/toastification.dart';

class Toast {
  static void show(
    String message, {
    ToastificationType type = ToastificationType.info,
  }) {
    toastification.show(
      autoCloseDuration: Duration(milliseconds: 2500),
      type: type,
      closeButton: ToastCloseButton(showType: CloseButtonShowType.none),
      description: Text(message, style: AppTextStyles.body3),
    );
  }
}
