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

  /// Generates a random color that is aesthetically pleasing (HSV method).
  static Color generatePleasingRandomColor(Random random) {
    final double hue = random.nextDouble() * 360;
    final double saturation =
        0.6 + (random.nextDouble() * 0.4); // Min 60% saturation
    final double value =
        0.8 + (random.nextDouble() * 0.2); // Min 80% brightness
    return HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
  }
}
