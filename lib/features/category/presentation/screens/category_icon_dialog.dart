part of 'category_form_screen.dart';

class CategoryIconDialog extends StatelessWidget {
  final ValueNotifier<String> icon;
  final ValueNotifier<String> iconBackground;
  final ValueNotifier<IconType> iconType;

  const CategoryIconDialog({
    super.key,
    required this.icon,
    required this.iconBackground,
    required this.iconType,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: 'Icon Type',
      child: AspectRatio(
        aspectRatio: 3 / 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () async {
                icon.value =
                    await context.openBottomSheet<String>(
                      child: CategoryIconEmojiPicker(),
                    ) ??
                    '';
                iconBackground.value = '';
                iconType.value = IconType.emoji;
                if (context.mounted) context.pop();
              },
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Card(
                  color: context.purpleBackground,
                  elevation: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    spacing: AppSpacing.spacing4,
                    children: [
                      Text('😀', style: AppTextStyles.heading3),
                      Text('Emoji'),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                icon.value =
                    await context.push(Routes.categoryIconAssetPicker) ?? '';
                Log.d(icon.value, label: 'icon path');
                iconBackground.value = '';
                iconType.value = IconType.asset;
                if (context.mounted) context.pop();
              },
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Card(
                  color: context.purpleBackground,
                  elevation: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    spacing: AppSpacing.spacing4,
                    children: [
                      Text('🖼️', style: AppTextStyles.heading3),
                      Text('Asset'),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                icon.value =
                    await context.openBottomSheet<String>(
                      child: CategoryIconInitialPicker(),
                    ) ??
                    '';
                iconBackground.value = '';
                iconType.value = IconType.initial;
                if (context.mounted) context.pop();
              },
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Card(
                  color: context.purpleBackground,
                  elevation: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    spacing: AppSpacing.spacing4,
                    children: [
                      Text('🅰️', style: AppTextStyles.heading3),
                      Text('Initial'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
