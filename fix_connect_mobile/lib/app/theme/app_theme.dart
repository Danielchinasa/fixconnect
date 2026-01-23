import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.primaryLight,

    textTheme: TextTheme(
      titleLarge: AppTextStyles.heading.copyWith(color: AppColors.primaryLight),
      bodyMedium: AppTextStyles.body,
      bodySmall: AppTextStyles.description,
    ),

    colorScheme: ColorScheme.light(
      primary: AppColors.primaryLight,
      secondary: AppColors.secondary,
      error: AppColors.error,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.primaryDark,

    textTheme: TextTheme(
      titleLarge: AppTextStyles.heading.copyWith(color: AppColors.primaryDark),
      bodyMedium: AppTextStyles.body,
      bodySmall: AppTextStyles.description,
    ),

    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryDark,
      secondary: AppColors.secondary,
      error: AppColors.error,
    ),
  );
}
