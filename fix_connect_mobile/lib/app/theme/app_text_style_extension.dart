import 'package:flutter/material.dart';

class AppTextStyleExtension extends ThemeExtension<AppTextStyleExtension> {
  final TextStyle bodyLargeSemibold;
  const AppTextStyleExtension({required this.bodyLargeSemibold});

  @override
  ThemeExtension<AppTextStyleExtension> copyWith({
    TextStyle? bodyLargeSemibold,
  }) {
    return AppTextStyleExtension(
      bodyLargeSemibold: bodyLargeSemibold ?? this.bodyLargeSemibold,
    );
  }

  @override
  ThemeExtension<AppTextStyleExtension> lerp(
    covariant ThemeExtension<AppTextStyleExtension>? other,
    double t,
  ) {
    // TODO: implement lerp
    throw UnimplementedError();
  }
}
