import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.spacing20,
          0,
          AppSpacing.spacing20,
          AppSpacing.spacing20,
        ),
        child: Column(
          children: [
            Text(title, style: AppTextStyles.body1),
            const Gap(AppSpacing.spacing32),
            ...[child],
          ],
        ),
      ),
    );
  }
}
