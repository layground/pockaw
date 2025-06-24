import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/bottom_sheets/alert_bottom_sheet.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/components/scaffolds/photo_viewer.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/services/image_service/riverpod/image_notifier.dart';
import 'package:pockaw/core/utils/logger.dart';

class TransactionImagePreview extends ConsumerWidget {
  const TransactionImagePreview({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final imageState = ref.watch(imageProvider);

    Log.d(imageState.imageFile?.path, label: 'imageState.imageFile');
    Log.d(imageState.savedPath, label: 'imageState.savedPath');

    if (imageState.imageFile == null) {
      return Container();
    }

    return Stack(
      children: [
        InkWell(
          onTap: () {
            if (imageState.imageFile == null) {
              return;
            }

            showAdaptiveDialog(
              context: context,
              builder: (context) =>
                  PhotoViewer(image: Image.file(imageState.imageFile!)),
            );
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(AppSpacing.spacing8),
              border: Border.all(color: AppColors.neutralAlpha25),
            ),
            child: Image.file(
              imageState.imageFile!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Center(child: Icon(HugeIcons.strokeRoundedImageNotFound01)),
            ),
          ),
        ),
        Positioned(
          right: 2,
          top: 2,
          child: CustomIconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                builder: (context) => AlertBottomSheet(
                  title: 'Delete Image',
                  content: Text(
                    'Are you sure you want to delete this image?',
                    style: AppTextStyles.body2,
                  ),
                  onConfirm: () {
                    context.pop(); // close dialog
                    ref.read(imageProvider.notifier).clearImage();
                  },
                ),
              );
            },
            icon: HugeIcons.strokeRoundedCancel01,
            backgroundColor: AppColors.red50,
            borderColor: AppColors.redAlpha10,
            color: AppColors.red,
            iconSize: IconSize.tiny,
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }
}
