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
      return context.isDarkMode ? AppColors.dark : AppColors.primary;
    }

    return context.isDarkMode ? AppColors.darkGrey : AppColors.neutral400;
  }
}

final pageControllerProvider = NotifierProvider<PageControllerNotifier, int>(
  PageControllerNotifier.new,
);
