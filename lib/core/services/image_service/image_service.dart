import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
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
      if (await file.exists()) {
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
