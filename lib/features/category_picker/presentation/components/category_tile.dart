import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';

class CategoryTile extends ConsumerWidget {
  final CategoryModel category;
  final double? height;
  final double? iconSize;
  final IconData? suffixIcon;
  final GestureTapCallback? onSuffixIconPressed;
  final Function(CategoryModel)? onSelectCategory;
  const CategoryTile({
    super.key,
    required this.category,
    this.onSuffixIconPressed,
    this.onSelectCategory,
    this.suffixIcon,
    this.height,
    this.iconSize = AppSpacing.spacing32,
  });

  @override
  Widget build(BuildContext context, ref) {
    final themeMode = ref.watch(themeModeProvider);

    return InkWell(
      onTap: () => onSelectCategory?.call(category),
      child: Container(
        height: height,
        padding: const EdgeInsets.all(AppSpacing.spacing4),
        decoration: BoxDecoration(
          color: context.secondaryBackground(themeMode),
          borderRadius: BorderRadius.circular(AppRadius.radius8),
          border: Border.all(color: context.secondaryBorder(themeMode)),
        ),
        child: Row(
          children: [
            Container(
              height: 54,
              width: 54,
              padding: const EdgeInsets.all(AppSpacing.spacing8),
              decoration: BoxDecoration(
                color: AppColors.secondaryAlpha10,
                borderRadius: BorderRadius.circular(AppRadius.radius8),
                border: Border.all(color: AppColors.secondaryAlpha10),
              ),
              child: category.icon.isEmpty
                  ? Icon(HugeIcons.strokeRoundedPizza01, size: iconSize)
                  : Image.asset(category.icon, width: iconSize),
            ),
            const Gap(AppSpacing.spacing8),
            Expanded(child: Text(category.title, style: AppTextStyles.body3)),
            if (suffixIcon != null)
              CustomIconButton(
                onPressed: onSuffixIconPressed ?? () {},
                icon: suffixIcon!,
                iconSize: IconSize.small,
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
      ),
    );
  }
}
