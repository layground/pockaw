import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/core/router/routes.dart';
import 'package:pockaw/features/currency_picker/data/models/currency.dart';
import 'package:pockaw/features/currency_picker/presentation/riverpod/currency_picker_provider.dart';

class CurrencyPickerField extends HookConsumerWidget {
  const CurrencyPickerField({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    Currency currency = ref.watch(currencyProvider);
    final currencyController = useTextEditingController();

    return Stack(
      children: [
        CustomTextField(
          controller: currencyController,
          label: 'Currency',
          hint: '\$ • US Dollar',
          prefixIcon: TablerIcons.flag,
          readOnly: true,
          onTap: () async {
            final Currency? selectedCurrency =
                await context.push(Routes.currencyListTile);
            if (selectedCurrency != null) {
              ref.read(currencyProvider.notifier).state = selectedCurrency;
              currencyController.text = selectedCurrency.name;
            }
          },
        ),
        Positioned(
          right: 10,
          bottom: 16,
          top: 16,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                AppRadius.radius4,
              ),
              border: Border.all(
                color: AppColors.neutralAlpha25,
              ),
            ),
            child: currency.country.isEmpty
                ? Container(
                    width: 40,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.radius4),
                      color: AppColors.neutral100,
                    ),
                  )
                : CountryFlag.fromCountryCode(
                    currency.countryCode,
                    width: 40,
                    height: 32,
                    shape: const RoundedRectangle(AppRadius.radius4),
                  ),
          ),
        )
      ],
    );

    return InkWell(
      onTap: () async {
        final Currency? selectedCurrency =
            await context.push(Routes.currencyListTile);
        if (selectedCurrency != null) {
          ref.read(currencyProvider.notifier).state = selectedCurrency;
          currencyController.text = '${currency.country} ${currency.name}';
        }
      },
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
                  CustomTextField(
                    controller: currencyController,
                    label: 'Currency',
                    hint: '\$ • US Dollar',
                    prefixIcon: TablerIcons.flag,
                    readOnly: true,
                    onTap: () => context.push(Routes.currencyListTile),
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  AppRadius.radius4,
                ),
                border: Border.all(
                  color: AppColors.neutralAlpha25,
                ),
              ),
              child: currency.country.isEmpty
                  ? Container(
                      width: 40,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.radius4),
                        color: AppColors.neutral100,
                      ),
                    )
                  : CountryFlag.fromCountryCode(
                      currency.countryCode,
                      width: 40,
                      height: 32,
                      shape: const RoundedRectangle(AppRadius.radius4),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
