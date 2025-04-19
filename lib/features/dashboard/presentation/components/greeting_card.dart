part of '../screens/dashboard_screen.dart';

class GreetingCard extends ConsumerWidget {
  const GreetingCard({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authStateProvider);

    return Row(
      children: [
        auth.profilePicture == null
            ? const CircleIconButton(
                icon: TablerIcons.photo,
                radius: 25,
                backgroundColor: AppColors.secondary100,
                foregroundColor: AppColors.secondary800,
              )
            : CircleAvatar(
                backgroundImage: FileImage(File(auth.profilePicture!)),
              ),
        const Gap(AppSpacing.spacing12),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning,',
              style: AppTextStyles.body4.copyWith(color: AppColors.neutral600),
            ),
            Text(
              auth.name,
              style: AppTextStyles.body2.copyWith(color: AppColors.dark),
            ),
          ],
        )
      ],
    );
  }
}
