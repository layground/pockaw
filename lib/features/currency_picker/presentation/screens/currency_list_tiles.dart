import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/loading_indicators/loading_indicator.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_radius.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/constants/app_text_styles.dart';
import 'package:pockaw/features/currency_picker/presentation/riverpod/currency_picker_provider.dart';

class CurrencyListTiles extends ConsumerWidget {
  const CurrencyListTiles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currenciesAsyncValue = ref.watch(currenciesProvider);

    return CustomScaffold(
      context: context,
      title: 'Choose Currency',
      showBalance: false,
      body: currenciesAsyncValue.when(
        data: (currencies) {
          if (currencies.isEmpty) {
            return const Center(child: Text('No currencies available.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacing20,
              vertical: AppSpacing.spacing20,
            ),
            itemCount: currencies.length,
            itemBuilder: (context, index) {
              final currency = currencies[index];
              return InkWell(
                onTap: () {
                  context.pop(currency);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.spacing12,
                    horizontal: AppSpacing.spacing20,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.neutral50,
                    borderRadius: BorderRadius.circular(AppRadius.radius8),
                    border: Border.all(color: AppColors.neutralAlpha50),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(currency.name, style: AppTextStyles.body2),
                            const Gap(AppSpacing.spacing4),
                            Chip(
                              label: Text(
                                currency.symbol,
                                style: AppTextStyles.body3,
                              ),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          currency.countryCode.isEmpty
                              ? const SizedBox(height: 32)
                              : Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.radius4,
                                    ),
                                    border: Border.all(
                                      color: AppColors.neutralAlpha25,
                                    ),
                                  ),
                                  child: CountryFlag.fromCountryCode(
                                    currency.countryCode,
                                    width: 40,
                                    height: 32,
                                    shape: const RoundedRectangle(
                                      AppRadius.radius4,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) =>
                const Gap(AppSpacing.spacing12),
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Error loading currencies: $error')),
      ),
    );
  }
}
