import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/primary_button.dart';
import 'package:pockaw/core/components/dialogs/toast.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/services/image_service/image_service.dart';
import 'package:pockaw/features/authentication/presentation/riverpod/auth_provider.dart';
import 'package:toastification/toastification.dart';

class PersonalDetailsScreen extends HookConsumerWidget {
  const PersonalDetailsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authStateProvider);
    final nameField = useTextEditingController();
    final profilePicture = useState<File?>(null);

    useEffect(() {
      nameField.text = auth.name;
      if (auth.profilePicture != null) {
        profilePicture.value = File(auth.profilePicture!);
      }

      return null;
    }, [auth]);

    return CustomScaffold(
      context: context,
      title: 'Personal Details',
      showBalance: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Form(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.spacing20,
                AppSpacing.spacing16,
                AppSpacing.spacing20,
                100,
              ),
              child: Column(
                spacing: AppSpacing.spacing16,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final imageService = ImageService();
                      final pickedImage = await imageService.pickImage(context);
                      if (pickedImage != null) {
                        profilePicture.value = File(pickedImage.path);
                      }
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.darkAlpha30,
                          // Use colorScheme.surfaceVariant for a subtle background
                          radius: 70,
                          child: CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surface, // Use colorScheme.surface
                            backgroundImage: profilePicture.value != null
                                ? FileImage(profilePicture.value!)
                                : null,
                            radius: 69,
                            child: profilePicture.value == null
                                ? Icon(
                                    Icons.camera_alt,
                                    color: AppColors.darkAlpha30,
                                    size: 40,
                                  )
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(AppSpacing.spacing8),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              HugeIcons.strokeRoundedCamera02,
                              size: 20,
                              color: AppColors.neutral200,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomTextField(
                    controller: nameField,
                    label: 'Name',
                    hint: 'John Doe',
                  ),
                ],
              ),
            ),
          ),
          PrimaryButton(
            label: 'Save',
            onPressed: () {
              final newName = nameField.text.trim();
              if (newName.isEmpty) {
                Toast.show(
                  'Name cannot be empty.',
                  type: ToastificationType.warning,
                );
                return;
              }

              final authNotifier = ref.read(authStateProvider.notifier);
              final currentUser = authNotifier.getUser();

              // The `setUser` method will handle the database update logic.
              authNotifier.setUser(
                currentUser.copyWith(
                  name: newName,
                  profilePicture: profilePicture.value?.path,
                ),
              );

              Toast.show(
                'Personal details updated!',
                type: ToastificationType.success,
              );

              if (context.mounted) context.pop();
            },
          ).floatingBottomContained,
        ],
      ),
    );
  }
}
