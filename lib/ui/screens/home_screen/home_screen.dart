import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pockaw/ui/screens/components/custom_bottom_app_bar.dart';
import 'package:pockaw/ui/screens/home_screen/components/home_app_bar.dart';
import 'package:pockaw/ui/screens/home_screen/components/home_balance_card.dart';
import 'package:pockaw/ui/screens/home_screen/components/home_transaction_card.dart';
import 'package:pockaw/ui/screens/home_screen/components/my_goals_carousel.dart';
import 'package:pockaw/ui/screens/home_screen/components/recent_transaction_list.dart';
import 'package:pockaw/ui/themes/app_colors.dart';
import 'package:pockaw/ui/themes/app_font_weights.dart';
import 'package:pockaw/ui/themes/app_radius.dart';
import 'package:pockaw/ui/themes/app_spacing.dart';
import 'package:pockaw/ui/themes/app_text_styles.dart';
import 'package:pockaw/ui/widgets/progress_indicators/custom_progress_indicator.dart';
import 'package:pockaw/ui/widgets/progress_indicators/custom_progress_indicator_legend.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              const HomeAppBar(),
              Container(
                margin: const EdgeInsets.all(AppSpacing.spacing20),
                child: Column(
                  children: [
                    const HomeBalanceCard(),
                    const Gap(AppSpacing.spacing12),
                    const Row(
                      children: [
                        Expanded(
                          child: HomeTransactionCard(
                            title: 'Income',
                            amount: 589234,
                            amountLastMonth: 123000,
                            titleColor: AppColors.secondary300,
                            backgroundColor: AppColors.secondary,
                            amountColor: AppColors.secondary100,
                            statsBackgroundColor: AppColors.primaryAlpha20,
                            statsForegroundColor: AppColors.secondary100,
                            statsIconColor: AppColors.green100,
                          ),
                        ),
                        Gap(AppSpacing.spacing12),
                        Expanded(
                          child: HomeTransactionCard(
                            title: 'Expense',
                            amount: 763120,
                            amountLastMonth: 335900,
                            backgroundColor: AppColors.tertiary900,
                            titleColor: AppColors.primary600,
                            amountColor: AppColors.secondary,
                            statsBackgroundColor: AppColors.primaryAlpha20,
                            statsForegroundColor: AppColors.secondary1000,
                            statsIconColor: AppColors.red200,
                          ),
                        ),
                      ],
                    ),
                    const Gap(AppSpacing.spacing12),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Where my money goes this month',
                              style: AppTextStyles.body4.copyWith(
                                fontVariations: [AppFontWeights.medium],
                              ),
                            ),
                            InkWell(
                              child: Text(
                                'See all reports',
                                style: AppTextStyles.body5.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(AppSpacing.spacing8),
                        const Row(
                          children: [
                            CustomProgressIndicator(
                              value: 0.35,
                              color: Color(0xFF93DBF3),
                              radius: BorderRadius.horizontal(
                                left: Radius.circular(AppRadius.radiusFull),
                              ),
                            ),
                            CustomProgressIndicator(
                              value: 0.3,
                              color: Color(0xFFE27DE5),
                            ),
                            CustomProgressIndicator(
                              value: 0.2,
                              color: Color(0xFFA0EBA1),
                            ),
                            CustomProgressIndicator(
                              value: 0.15,
                              color: Color(0xFFEBC58F),
                              radius: BorderRadius.horizontal(
                                right: Radius.circular(AppRadius.radiusFull),
                              ),
                            ),
                          ],
                        ),
                        const Gap(AppSpacing.spacing8),
                        const Row(
                          children: [
                            CustomProgressIndicatorLegend(
                              label: 'Electronics',
                              color: Color(0xFF93DBF3),
                            ),
                            Gap(AppSpacing.spacing8),
                            CustomProgressIndicatorLegend(
                              label: 'Bills',
                              color: Color(0xFFE27DE5),
                            ),
                            Gap(AppSpacing.spacing8),
                            CustomProgressIndicatorLegend(
                              label: 'Food',
                              color: Color(0xFFA0EBA1),
                            ),
                            Gap(AppSpacing.spacing8),
                            CustomProgressIndicatorLegend(
                              label: 'Groceries',
                              color: Color(0xFFEBC58F),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const MyGoalsCarousel(),
              const RecentTransactionList(),
            ],
          ),
          const Positioned(
            bottom: 20,
            left: 94,
            right: 94,
            child: CustomBottomAppBar(),
          ),
        ],
      ),
    );
  }
}
