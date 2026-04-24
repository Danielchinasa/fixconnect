import 'package:flutter/material.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color? surfaceSelected;
  final Color? surface;
  const AppThemeExtension({this.surfaceSelected, this.surface});

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? surfaceSelected,
    Color? surface,
  }) {
    return AppThemeExtension(
      surfaceSelected: surfaceSelected ?? this.surfaceSelected,
      surface: surface ?? this.surface,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    covariant ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      surfaceSelected: Color.lerp(surfaceSelected, other.surfaceSelected, t),
      surface: Color.lerp(surface, other.surface, t),
    );
  }
}
