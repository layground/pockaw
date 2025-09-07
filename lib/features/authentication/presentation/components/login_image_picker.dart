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

    return GestureDetector(
      onTap: () async {
        KeyboardService.closeKeyboard();
        showModalBottomSheet(
          context: context,
          showDragHandle: true,
          builder: (context) => CustomBottomSheet(
            title: 'Pick Image',
            child: ImagePickerDialog(
              onTakePhoto: (filePath) {
                ref.read(loginImageProvider.notifier).takePhoto().then((value) {
                  ref.read(loginImageProvider.notifier).saveImage();
                  ref.read(authStateProvider.notifier).getUser();
                  if (context.mounted) context.pop();
                });
              },
              onPickImage: () {
                ref.read(loginImageProvider.notifier).pickImage().then((value) {
                  ref.read(loginImageProvider.notifier).saveImage();
                  ref.read(authStateProvider.notifier).getUser();
                  if (context.mounted) context.pop();
                });
              },
            ),
          ),
        );
      },
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: context.secondaryBackground,
            radius: 70,
            child: CircleAvatar(
              backgroundColor: context.placeholderBackground,
              backgroundImage: image.imageFile != null
                  ? Image.file(image.imageFile!).image
                  : null,
              radius: 69,
              child: image.imageFile == null
                  ? Icon(
                      HugeIcons.strokeRoundedUpload04,
                      color: context.purpleIcon,
                      size: 40,
                    )
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(AppSpacing.spacing8),
              decoration: BoxDecoration(
                color: context.secondaryBackgroundSolid,
                shape: BoxShape.circle,
              ),
              child: Icon(HugeIcons.strokeRoundedCamera02, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
