import 'package:flutter/material.dart';

class AppColors {
  static const Color pinkLight = Color(0xFFFF7E9D);
  static const Color pinkMid = Color(0xFFFFB6C1);
  static const Color pinkAccent = Color(0xFF9358F7);

  static LinearGradient romanticGradient = const LinearGradient(
    colors: [pinkLight, pinkMid, pinkAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color glassWhite = Colors.white70;
}
