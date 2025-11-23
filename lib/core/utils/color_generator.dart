import 'dart:math';

import 'package:flutter/material.dart';

class ColorGenerator {
  /// Generates a completely random color.
  ///
  /// This creates a color by randomizing the Red, Green, and Blue channels
  /// between 0 and 255. The opacity is always set to 1.0 (fully opaque).
  static Color generateRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255, // Alpha (Opacity) - 255 means fully opaque
      random.nextInt(256), // Red (0-255)
      random.nextInt(256), // Green (0-255)
      random.nextInt(256), // Blue (0-255)
    );
  }
}
