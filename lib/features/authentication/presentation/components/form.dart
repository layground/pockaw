part of '../screens/login_screen.dart';

class Form extends HookConsumerWidget {
  final TextEditingController nameField;
  const Form({super.key, required this.nameField});

  @override
  Widget build(BuildContext context, ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Get Started', style: AppTextStyles.heading5),
              Gap(AppSpacing.spacing4),
              GetStartedDescription(),
            ],
          ),
          const Gap(AppSpacing.spacing20),
          Column(
            spacing: AppSpacing.spacing16,
            children: [
              IntrinsicHeight(
                child: Row(
                  spacing: AppSpacing.spacing8,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: nameField,
                        label: 'Name',
                        hint: 'John Doe',
                        prefixIcon: HugeIcons.strokeRoundedTextSmallcaps,
                      ),
                    ),
                    const LoginImagePicker(),
                  ],
                ),
              ),
              const CreateFirstWalletField(),
            ],
          ),
          const Gap(AppSpacing.spacing20),
          const LoginInfo(),
          const Gap(AppSpacing.spacing56),
        ],
      ),
    );
  }
}
