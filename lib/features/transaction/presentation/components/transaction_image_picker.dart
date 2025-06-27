import 'dart:io';

import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/secondary_button.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/services/image_service/riverpod/image_notifier.dart';

class TransactionImagePicker extends ConsumerWidget {
  const TransactionImagePicker({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final imageNotifier = ref.read(imageProvider.notifier);

    return Row(
      children: [
        if (Platform.isAndroid || Platform.isIOS)
          Expanded(
            child: SecondaryButton(
              context: context,
              onPressed: () async {
                imageNotifier.takePhoto().then((value) {
                  imageNotifier.saveImage();
                });
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
              imageNotifier.pickImage().then((value) {
                imageNotifier.saveImage();
              });
            },
            label: 'Gallery',
            icon: HugeIcons.strokeRoundedImage01,
          ),
        ),
      ],
    );
  }
}
