import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pockaw/core/components/buttons/circle_button.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/features/authentication/data/models/user_model.dart';
import 'package:pockaw/features/authentication/presentation/riverpod/auth_provider.dart';

class ProfilePicture extends ConsumerWidget {
  final double radius;
  const ProfilePicture({super.key, this.radius = 25});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);

    final errorPicture = CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.secondary100,
      child: HugeIcon(
        icon: HugeIcons.strokeRoundedUser,
        color: AppColors.secondary800,
      ),
    );

    return !auth.hasProfilePicture
        ? CircleIconButton(
            icon: HugeIcons.strokeRoundedUser,
            radius: radius,
            backgroundColor: AppColors.secondary100,
            foregroundColor: AppColors.secondary800,
          )
        : auth.hasNetworkProfilePicture
        ? CachedNetworkImage(
            imageUrl: auth.profilePicture!,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: radius,
              backgroundImage: imageProvider,
            ),
            placeholder: (context, url) => CircleAvatar(
              radius: radius,
              backgroundColor: AppColors.secondary100,
            ),
            errorWidget: (context, url, error) => errorPicture,
          )
        : auth.hasLocalProfilePicture
        ? errorPicture
        : CircleAvatar(
            radius: radius,
            backgroundImage: FileImage(File(auth.profilePicture!)),
          );
  }
}
