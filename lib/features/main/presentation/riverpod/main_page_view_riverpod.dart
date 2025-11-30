import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/constants/app_colors.dart';

class PageControllerNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setPage(int page) {
    state = page;
  }

  Color getIconColor(BuildContext context, int page) {
    if (state == page) {
      return context.isDarkMode ? AppColors.primary500 : AppColors.primary600;
    }

    return context.isDarkMode ? AppColors.neutral100 : AppColors.neutral500;
  }
}

final pageControllerProvider = NotifierProvider<PageControllerNotifier, int>(
  PageControllerNotifier.new,
);
