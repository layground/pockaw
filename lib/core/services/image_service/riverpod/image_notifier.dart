import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/services/image_service/domain/image_state.dart';
import 'package:pockaw/core/services/image_service/riverpod/image_service_provider.dart';

/// Migrated from StateNotifier to Notifier (Riverpod 3 pattern)
class ImageNotifier extends Notifier<ImageState> {
  @override
  ImageState build() {
    // Initialize image service by watching the provider (ensures it's available).
    ref.watch(imageServiceProvider);
    return ImageState();
  }

  Future<String?> pickImage() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final imageService = ref.read(imageServiceProvider);
      final image = await imageService.pickImageFromGallery();
      state = state.copyWith(imageFile: image, isLoading: false);
      return state.savedPath;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to pick image: $e',
        isLoading: false,
      );
    }

    return '';
  }

  Future<String?> takePhoto() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final imageService = ref.read(imageServiceProvider);
      final image = await imageService.takePhoto();
      state = state.copyWith(imageFile: image, isLoading: false);
      return state.savedPath;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to take photo: $e',
        isLoading: false,
      );
    }
    return '';
  }

  Future<String?> saveImage() async {
    if (state.imageFile == null) return null;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final imageService = ref.read(imageServiceProvider);
      final savedPath = await imageService.saveImage(state.imageFile!);
      state = state.copyWith(savedPath: savedPath, isLoading: false);
      return savedPath;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to save image: $e',
        isLoading: false,
      );

      return null;
    }
  }

  Future<bool> deleteImage() async {
    if (state.savedPath == null) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final imageService = ref.read(imageServiceProvider);
      final success = await imageService.deleteImage(state.savedPath!);

      if (!success) {
        state = state.clear();
      } else {
        state = state.copyWith(isLoading: false);
      }

      return success;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete image: $e',
        isLoading: false,
      );

      return false;
    }
  }

  /// Loads an image from a given file path and updates the state.
  /// This is useful for displaying an existing image.
  void loadImagePath(String path) {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final imageFile = File(path);
      // We assume the path provided is already a saved/persistent path.
      state = state.copyWith(
        imageFile: imageFile,
        savedPath: path,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load image from path: $e',
        isLoading: false,
      );
    }
  }

  void clearImage() {
    state = state.clear();
  }
}

final imageProvider = NotifierProvider<ImageNotifier, ImageState>(
  ImageNotifier.new,
);
