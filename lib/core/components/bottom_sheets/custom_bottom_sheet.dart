import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/extensions/text_style_extensions.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsets? padding;

  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding:
            padding ??
            const EdgeInsets.fromLTRB(
              AppSpacing.spacing20,
              0,
              AppSpacing.spacing20,
              AppSpacing.spacing20,
            ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: AppTextStyles.body1.bold),
              const Gap(AppSpacing.spacing32),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
