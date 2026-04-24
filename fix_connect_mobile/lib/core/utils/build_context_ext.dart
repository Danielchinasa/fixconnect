import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Shorthand theme helpers available on every [BuildContext].
/// Eliminates the repeated 6-line theme setup in every build method.
extension AppBuildContext on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get textColor => isDark ? AppColors.darkText : AppColors.lightText;
  Color get subTextColor => isDark ? AppColors.grey500 : AppColors.grey600;
  Color get surfaceColor =>
      isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
  Color get bgColor =>
      isDark ? AppColors.darkBackground : AppColors.lightBackground;
  Color get primary => Theme.of(this).colorScheme.primary;
}
