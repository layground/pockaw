import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/router/routes.dart';

class CurrencyPickerField extends StatelessWidget {
  const CurrencyPickerField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.currencyListTile),
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.radius8),
          color: AppColors.light,
          border: Border.all(
            color: AppColors.neutralAlpha50,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              TablerIcons.flag,
              color: AppColors.neutral700,
            ),
            const Gap(AppSpacing.spacing12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Currency',
                    style: AppTextStyles.body5.copyWith(
                      color: AppColors.neutral600,
                    ),
                  ),
                  TextField(
                    style: AppTextStyles.body2,
                    readOnly: true,
                    onTap: () => context.push(Routes.currencyListTile),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: AppColors.light,
                      hintText: '\$ • US Dollar ',
                      hintStyle: AppTextStyles.body2.copyWith(
                        color: AppColors.neutral300,
                      ),
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 48,
              height: 36,
              color: AppColors.neutral200,
            ),
          ],
        ),
      ),
    );
  }
}
