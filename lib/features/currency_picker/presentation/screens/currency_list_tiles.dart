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
import 'package:pockaw/features/theme_switcher/presentation/riverpod/theme_mode_provider.dart';

class CurrencyListTiles extends ConsumerWidget {
  const CurrencyListTiles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.read(themeModeProvider);
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
                    vertical: AppSpacing.spacing8,
                    horizontal: AppSpacing.spacing8,
                  ),
                  decoration: BoxDecoration(
                    color: context.purpleBackground(themeMode),
                    borderRadius: BorderRadius.circular(AppRadius.radius8),
                    border: Border.all(
                      color: context.purpleBorderLighter(themeMode),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              padding: EdgeInsets.all(AppSpacing.spacing8),
                              decoration: BoxDecoration(
                                color: context.purpleButtonBackground(
                                  themeMode,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.radius4,
                                ),
                                border: Border.all(
                                  color: context.purpleButtonBorder(themeMode),
                                ),
                              ),
                              child: Text(
                                currency.symbol,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.body3.copyWith(
                                  color: context.purpleText(themeMode),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const Gap(AppSpacing.spacing8),
                            Text(currency.name, style: AppTextStyles.body2),
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
                                      color: context.purpleBorderLighter(
                                        themeMode,
                                      ),
                                    ),
                                  ),
                                  child: CountryFlag.fromCountryCode(
                                    currency.countryCode,
                                    width: 44,
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
                const Gap(AppSpacing.spacing8),
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Error loading currencies: $error')),
      ),
    );
  }
}
