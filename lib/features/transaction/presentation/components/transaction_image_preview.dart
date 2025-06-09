import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/services/image_service/riverpod/image_notifier.dart';

class TransactionImagePreview extends ConsumerWidget {
  const TransactionImagePreview({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final imageState = ref.watch(imageProvider);
    final imageNotifier = ref.read(imageProvider.notifier);

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(AppSpacing.spacing8),
        border: Border.all(color: AppColors.neutralAlpha25),
        image: imageState.imageFile == null
            ? null
            : DecorationImage(
                image: FileImage(imageState.imageFile!),
                fit: BoxFit.cover,
              ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 5,
            top: 5,
            child: CustomIconButton(
              onPressed: () {
                imageNotifier.clearSelection();
              },
              icon: HugeIcons.strokeRoundedDelete01,
              backgroundColor: AppColors.red50,
              borderColor: AppColors.redAlpha10,
              color: AppColors.red,
              iconSize: IconSize.tiny,
              visualDensity: VisualDensity.compact,
            ),
          )
        ],
      ),
    );
  }
}
