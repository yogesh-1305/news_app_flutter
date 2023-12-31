import 'package:flutter/material.dart';

class AppColors {
  static const Color colorPrimary = Color(0xFFFFFFFF);
  static const Color colorOnPrimary = Color(0xFF1A1A1A);
  static const Color colorPrimaryDark = Color(0xFF1F1F1F);
  static const Color colorOnPrimaryDark = Color(0xFFFFFFFF);
  static const Color colorAccent = Color(0xFF5b38e2);
  static const Color colorBackground = Color(0xFFE5E5E5);
  static const Color colorBackgroundDark = Color(0xFF262626);
  static const Color colorSurface = Color(0xFFFFFFFF);
  static const Color colorError = Color(0xFFB00020);
  static const Color colorOnBackground = Color(0xFF000000);
  static const Color colorOnSurface = Color(0xFF000000);

  static LinearGradient stackShadowGradient = LinearGradient(
    colors: [
      Colors.black.withOpacity(0.8),
      Colors.black.withOpacity(0.4),
      Colors.black.withOpacity(0.2),
      Colors.transparent,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
}
