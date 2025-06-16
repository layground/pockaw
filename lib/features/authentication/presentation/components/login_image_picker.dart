part of '../screens/login_screen.dart';

final loginImageServiceProvider = Provider<ImageService>((ref) {
  return ImageService();
});

final loginImageProvider = StateNotifierProvider<ImageNotifier, ImageState>((
  ref,
) {
  final imageService = ref.watch(loginImageServiceProvider);
  return ImageNotifier(imageService);
});

class LoginImagePicker extends ConsumerWidget {
  const LoginImagePicker({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final image = ref.watch(loginImageProvider);

    return InkWell(
      onTap: () {
        KeyboardService.closeKeyboard();
        ref.read(loginImageProvider.notifier).pickImage().then((value) {
          ref.read(loginImageProvider.notifier).saveImage();
          ref.read(authStateProvider.notifier).getUser();
        });
      },
      child: Container(
        height: double.infinity,
        width: 72,
        padding: const EdgeInsets.all(AppSpacing.spacing20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.radius8),
          color: AppColors.light,
          border: Border.all(color: AppColors.neutralAlpha50),
          image: image.imageFile == null
              ? null
              : DecorationImage(
                  image: Image.file(image.imageFile!).image,
                  fit: BoxFit.cover,
                ),
        ),
        child: image.imageFile == null
            ? const Icon(HugeIcons.strokeRoundedUpload01)
            : null,
      ),
    );
  }
}
