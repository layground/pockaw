import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/category/data/model/category_model.dart';
import 'package:pockaw/features/category_picker/presentation/components/category_icon.dart';

class CategoryTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelectCategory?.call(category),
      child: Container(
        height: height,
        padding: const EdgeInsets.all(AppSpacing.spacing8),
        decoration: BoxDecoration(
          color: context.purpleBackground(context.themeMode),
          borderRadius: BorderRadius.circular(AppRadius.radius8),
          border: Border.all(
            color: context.purpleBorderLighter(context.themeMode),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.all(AppSpacing.spacing8),
              decoration: BoxDecoration(
                color: context.purpleBackground(context.themeMode),
                borderRadius: BorderRadius.circular(AppRadius.radius8),
                border: Border.all(
                  color: context.purpleBorderLighter(context.themeMode),
                ),
              ),
              child: CategoryIcon(
                iconType: category.iconType,
                icon: category.icon,
                iconBackground: category.iconBackground,
              ),
            ),
            const Gap(AppSpacing.spacing8),
            Expanded(child: Text(category.title, style: AppTextStyles.body3)),
            if (suffixIcon != null)
              CustomIconButton(
                context,
                onPressed: onSuffixIconPressed ?? () {},
                icon: suffixIcon!,
                iconSize: IconSize.small,
                visualDensity: VisualDensity.compact,
                backgroundColor: context.purpleBackground(context.themeMode),
                borderColor: onSuffixIconPressed == null
                    ? Colors.transparent
                    : context.purpleBorderLighter(context.themeMode),
                color: context.purpleText(context.themeMode),
              ),
            const Gap(AppSpacing.spacing8),
          ],
        ),
      ),
    );
  }
}
