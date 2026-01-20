import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const _fontFamily = 'Inter';

  static const heading = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
}
