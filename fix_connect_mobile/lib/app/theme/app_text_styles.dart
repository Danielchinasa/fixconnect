import 'package:fix_connect_mobile/core/utils/screen_util.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static const _fontFamily = 'Inter';

  static double _scale(double size) {
    if (ScreenUtil.isTablet) return size * 1.15;
    if (ScreenUtil.isDesktop) return size * 1.3;
    return size; // Mobile
  }

  static final heading = TextStyle(
    fontFamily: _fontFamily,
    fontSize: _scale(54),
    fontWeight: FontWeight.bold,
  );

  static final body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: _scale(16),
    fontWeight: FontWeight.normal,
  );

  static final description = TextStyle(
    fontFamily: _fontFamily,
    fontSize: _scale(14),
    fontWeight: FontWeight.w400,
  );

  static final h2Heading = TextStyle(
    fontFamily: _fontFamily,
    fontSize: _scale(36),
    fontWeight: FontWeight.bold,
  );

  static final h3Heading = TextStyle(
    fontFamily: _fontFamily,
    fontSize: _scale(24),
    fontWeight: FontWeight.bold,
  );
}
