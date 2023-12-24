import 'package:flutter/material.dart';
import 'package:news_app_flutter/src/data_layer/res/app_colors.dart';
import 'package:news_app_flutter/src/data_layer/res/app_styles.dart';

class AppThemes {
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
    textTheme: TextTheme(
      headlineLarge: AppStyles.headline1,
      headlineMedium: AppStyles.headline2,
      headlineSmall: AppStyles.headline3,
    ),
  );

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
  );
}
