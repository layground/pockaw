part of '../screens/login_screen.dart';

final loginImageServiceProvider = Provider<ImageService>((ref) {
  return ImageService();
});

class LoginImageNotifier extends Notifier<ImageState> {
  late ImageService _imageService;

  Future<void> takePhoto() async {
    final result = await _imageService.takePhoto();
    if (result != null) {
      state = state.copyWith(imageFile: result);
    }
  }

  Future<void> pickImage(BuildContext context) async {
    final result = await _imageService.pickImage(context);
    if (result != null) {
      state = state.copyWith(imageFile: result);
    }
  }

  Future<void> saveImage() async {
    if (state.imageFile != null) {
      await _imageService.saveImage(state.imageFile!);
    }
  }

  void deleteImage() {
    state = state.copyWith(imageFile: null);
  }

  @override
  ImageState build() {
    _imageService = ref.watch(loginImageServiceProvider);
    return ImageState();
  }
}

final loginImageProvider = NotifierProvider<LoginImageNotifier, ImageState>(
  LoginImageNotifier.new,
);

class LoginImagePicker extends ConsumerWidget {
  const LoginImagePicker({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final image = ref.watch(loginImageProvider);

    return GestureDetector(
      onTap: () async {
        KeyboardService.closeKeyboard();
        context.openBottomSheet(
          child: Container(),
          builder: (sheetContext) => CustomBottomSheet(
            title: 'Pick Image',
            child: ImagePickerDialog(
              onTakePhoto: (filePath) {
                ref.read(loginImageProvider.notifier).takePhoto().then((value) {
                  ref.read(loginImageProvider.notifier).saveImage();
                  ref.read(authStateProvider.notifier).getUser();
                  if (sheetContext.mounted) sheetContext.pop();
                });
              },
              onPickImage: () {
                ref
                    .read(loginImageProvider.notifier)
                    .pickImage(sheetContext)
                    .then((value) {
                      ref.read(loginImageProvider.notifier).saveImage();
                      ref.read(authStateProvider.notifier).getUser();
                      if (sheetContext.mounted) sheetContext.pop();
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
                  ? HugeIcon(
                      icon: HugeIcons.strokeRoundedUpload04,
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
              child: HugeIcon(icon: HugeIcons.strokeRoundedCamera02, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
