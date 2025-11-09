import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/constants/app_colors.dart';

class PageControllerNotifier extends StateNotifier<int> {
  PageControllerNotifier() : super(0);

  void setPage(int page) {
    state = page;
  }

  Color getIconColor(int page) {
    if (state == page) {
      return AppColors.light;
    }

    return AppColors.neutral400;
  }
}

final pageControllerProvider =
    StateNotifierProvider<PageControllerNotifier, int>(
      (ref) => PageControllerNotifier(),
    );
