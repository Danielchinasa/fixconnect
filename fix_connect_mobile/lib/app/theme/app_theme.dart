import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.primaryLight,

    textTheme: TextTheme(
      titleLarge: AppTextStyles.heading.copyWith(color: AppColors.primaryLight),
      displayMedium: AppTextStyles.h3Heading.copyWith(
        color: AppColors.primaryLight,
      ),
      displayLarge: AppTextStyles.h2Heading.copyWith(
        color: AppColors.primaryLight,
      ),
      bodyMedium: AppTextStyles.body.copyWith(color: AppColors.lightText),
      bodySmall: AppTextStyles.description.copyWith(color: Colors.white70),
    ),

    colorScheme: ColorScheme.light(
      primary: AppColors.primaryLight,
      secondary: AppColors.secondary,
      surface: AppColors.lightBackground,
      error: AppColors.error,
    ),
  );

  // dark theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.primaryDark,

    textTheme: TextTheme(
      titleLarge: AppTextStyles.heading.copyWith(color: AppColors.primaryDark),
      displayLarge: AppTextStyles.h2Heading.copyWith(
        color: AppColors.primaryDark,
      ),
      displayMedium: AppTextStyles.h3Heading.copyWith(
        color: AppColors.primaryDark,
      ),
      bodyMedium: AppTextStyles.body.copyWith(color: AppColors.darkText),
      bodySmall: AppTextStyles.description.copyWith(color: Colors.white70),
    ),

    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryDark,
      secondary: AppColors.secondary,
      surface: AppColors.darkBackground,
      error: AppColors.error,
    ),
  );
}
