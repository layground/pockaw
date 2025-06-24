import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:pockaw/core/components/bottom_sheets/custom_bottom_sheet.dart';
import 'package:pockaw/core/components/buttons/secondary_button.dart';
import 'package:pockaw/core/constants/app_spacing.dart';
import 'package:pockaw/core/extensions/screen_utils_extensions.dart';
import 'package:pockaw/core/utils/logger.dart';
import 'package:uuid/uuid.dart';

class ImageService {
  final ImagePicker _imagePicker = ImagePicker();

  /// Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (image != null) {
      return File(image.path);
    }

    return null;
  }

  /// Take a photo with camera
  Future<File?> takePhoto() async {
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );

    if (photo != null) {
      return File(photo.path);
    }

    return null;
  }

  Future<File?> pickImage(BuildContext context) async {
    if (context.isDesktop || kIsWeb) {
      return await pickImageFromGallery();
    }

    return await showModalBottomSheet<File?>(
      context: context,
      showDragHandle: true,
      builder: (context) => CustomBottomSheet(
        title: 'Pick Image',
        child: Row(
          children: [
            Expanded(
              child: SecondaryButton(
                onPressed: () async {
                  final file = await takePhoto();
                  if (context.mounted) context.pop(file);
                },
                label: 'Camera',
                icon: HugeIcons.strokeRoundedCamera01,
              ),
            ),
            const Gap(AppSpacing.spacing8),
            Expanded(
              child: SecondaryButton(
                onPressed: () async {
                  final file = await pickImageFromGallery();
                  if (context.mounted) context.pop(file);
                },
                label: 'Gallery',
                icon: HugeIcons.strokeRoundedImage01,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Save image to app documents directory with a unique name
  Future<String?> saveImage(
    File imageFile, {
    String directory = 'pockaw_images',
  }) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${appDir.path}/$directory');

      // Create the directory if it doesn't exist
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      // Generate a unique filename
      final uuid = const Uuid().v4();
      final extension = path.extension(imageFile.path);
      final fileName = '$uuid$extension';

      // Copy the file to our app's directory
      final savedImage = await imageFile.copy('${imagesDir.path}/$fileName');

      Log.i(savedImage.path, label: 'save image');

      return savedImage.path;
    } catch (e) {
      Log.e('$e', label: 'save image');
      return null;
    }
  }

  /// Delete an image file
  Future<bool> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      final exists = await file.exists();
      Log.i(exists, label: 'delete image file');
      if (exists) {
        Log.i(file.path, label: 'deleting image');
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      Log.e(e, label: 'delete image');
      return false;
    }
  }
}
