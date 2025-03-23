import 'dart:io';

class ImageState {
  final File? imageFile;
  final String? savedPath;
  final bool isLoading;
  final String? error;

  ImageState({
    this.imageFile,
    this.savedPath,
    this.isLoading = false,
    this.error,
  });

  ImageState copyWith({
    File? imageFile,
    String? savedPath,
    bool? isLoading,
    String? error,
  }) {
    return ImageState(
      imageFile: imageFile ?? this.imageFile,
      savedPath: savedPath ?? this.savedPath,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  // Clear the current image selection
  ImageState clear() {
    return ImageState();
  }
}
