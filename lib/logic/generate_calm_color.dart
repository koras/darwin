import 'package:flutter/material.dart';

Color generateCalmColor(String input) {
  final hash = input.hashCode;
  return HSLColor.fromAHSL(
    1.0,
    (hash % 360).toDouble(), // Hue (0-360)
    0.4, // Saturation (умеренная для спокойных цветов)
    0.7, // Lightness (не слишком темный и не слишком светлый)
  ).toColor();
}
