part of '../screens/dashboard_screen.dart';

class SpendingProgressChart extends StatelessWidget {
  const SpendingProgressChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My spending this month',
              style: AppTextStyles.body4.copyWith(
                fontVariations: [AppFontWeights.medium],
              ),
            ),
            InkWell(
              child: Text(
                'View report',
                style: AppTextStyles.body5.copyWith(
                  decoration: TextDecoration.underline,
                  color: AppColors.neutral800,
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
    );
  }
}
