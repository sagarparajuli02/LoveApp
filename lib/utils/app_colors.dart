import 'package:flutter/material.dart';

class AppColors {
  // Base colors (used directly in UI).
  static const Color accentOrange = Color(0xFFec5b13);
  static const Color plum = Color(0xFF3b0764);
  static const Color wine = Color(0xFF831843);
  static const Color heartPink = Color(0xFFFF4C81);

  static const Color appBlack = Colors.black;
  static const Color textPrimary = Colors.white;

  // Surfaces.
  static const Color modalSurface = Color(0xFF1A1A1A);
  static const Color moodSheetSurface = Color(0xFF120C12);
  static const Color moodSelectedSurface = Color(0xFF2D1B15);

  // Alpha helpers (keeps this file small and avoids repeating many near-identical
  // "glassFillXX/glassBorderXX" fields).
  static Color whiteA(double alpha) => Colors.white.withValues(alpha: alpha);
  static Color blackA(double alpha) => Colors.black.withValues(alpha: alpha);

  // Gradients.
  static const LinearGradient romanticGradient = LinearGradient(
    colors: [wine, plum],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient backgroundTopRight = RadialGradient(
    center: Alignment.topRight,
    radius: 1.3,
    colors: [plum, appBlack],
  );
  static const RadialGradient backgroundBottomLeft = RadialGradient(
    center: Alignment.bottomLeft,
    radius: 1.2,
    colors: [wine, Colors.transparent],
  );

  static const LinearGradient moodCardGradient = LinearGradient(
    colors: [Color(0xFFf0754a), Color(0xFFa23ab7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient widgetGradient = LinearGradient(
    colors: [Color(0xFFee2b6c), Color(0xFF221016)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
