import 'package:flutter/material.dart';
import 'package:news_app_flutter/src/data_layer/res/app_colors.dart';

class AppThemes {
  /// light theme
  static final ThemeData light = ThemeData.light(
    useMaterial3: true,
  ).copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.colorPrimary,
      foregroundColor: AppColors.colorOnPrimary,
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.colorPrimary,
      onPrimary: AppColors.colorOnPrimary,
      background: AppColors.colorBackground,
    ),
    buttonTheme: const ButtonThemeData(
      colorScheme: ColorScheme.light(),
      buttonColor: AppColors.colorAccent,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  /// dark theme
  static final ThemeData dark = ThemeData.dark(
    useMaterial3: true,
  ).copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.colorPrimaryDark,
      foregroundColor: AppColors.colorOnPrimaryDark,
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.colorPrimaryDark,
      onPrimary: AppColors.colorOnPrimaryDark,
      background: AppColors.colorBackgroundDark,
    ),
    buttonTheme: const ButtonThemeData(
      colorScheme: ColorScheme.dark(),
      buttonColor: AppColors.colorAccent,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
