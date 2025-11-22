import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/components/buttons/custom_text_button.dart';
import 'package:pockaw/core/services/connectivity_service/connectivity_service.dart';
import 'package:pockaw/features/authentication/presentation/riverpod/auth_provider.dart';

class GoogleSignInButton extends ConsumerWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context, ref) {
    // use future builder to show button only if connection is available
    final connectionStatus = ref.watch(connectionStatusProvider);

    if (connectionStatus.value == ConnectionStatus.offline) {
      return const SizedBox.shrink();
    }

    return CustomTextButton(
      label: 'Sign in with Google',
      icon: Image.asset('assets/icon/search.png', width: 24, height: 24),
      onPressed: () => ref
          .read(authStateProvider.notifier)
          .signInWithGoogle(context: context),
    );
  }
}
