import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/secondary_button.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class ImagePickerDialog extends ConsumerWidget {
  final Function? onTakePhoto;
  final Function? onPickImage;
  const ImagePickerDialog({super.key, this.onTakePhoto, this.onPickImage});

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      children: [
        Icon(HugeIcons.strokeRoundedInformationSquare),
        Gap(AppSpacing.spacing12),
        Text(
          'Your selected image is used only to personalize your profile within this app. '
          'It is never transmitted, uploaded, or shared outside your device.',
          style: AppTextStyles.body3,
          textAlign: TextAlign.center,
        ),
        Gap(AppSpacing.spacing48),
        Row(
          children: [
            if (Platform.isAndroid || Platform.isIOS)
              Expanded(
                child: SecondaryButton(
                  context: context,
                  onPressed: () async {
                    onTakePhoto?.call();
                  },
                  label: 'Camera',
                  icon: HugeIcons.strokeRoundedCamera01,
                ),
              ),
            if (Platform.isAndroid || Platform.isIOS)
              const Gap(AppSpacing.spacing8),
            Expanded(
              child: SecondaryButton(
                context: context,
                onPressed: () {
                  onPickImage?.call();
                },
                label: 'Gallery',
                icon: HugeIcons.strokeRoundedImage01,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
