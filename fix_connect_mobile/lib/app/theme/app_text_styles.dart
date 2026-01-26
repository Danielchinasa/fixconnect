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

  static TextStyle bodyLargeBold({Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: color,
      height: 1.4,
      letterSpacing: 0.2,
    );
  }

  static TextStyle bodyLargeSemibold({Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color,
      height: 1.4,
      letterSpacing: 0.2,
    );
  }

  static TextStyle bodyLargeMedium({Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: color,
      height: 1.4,
      letterSpacing: 0.2,
    );
  }

  static TextStyle bodyLargeRegular({Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: color,
      height: 1.4,
      letterSpacing: 0.2,
    );
  }

  // Body Medium
  static TextStyle bodyMediumBold({Color? color}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: color,
      height: 1.4,
      letterSpacing: 0.2,
    );
  }

  static TextStyle bodyMediumSemibold({Color? color}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color,
      height: 1.4,
      letterSpacing: 0.2,
    );
  }

  static TextStyle bodyMediumMedium({Color? color}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color,
      height: 1.4,
      letterSpacing: 0.2,
    );
  }

  static TextStyle bodyMediumRegular({Color? color}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: color,
      height: 1.4,
      letterSpacing: 0.2,
    );
  }

  // Body Small
  static TextStyle bodySmallBold({Color? color}) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: color,
      letterSpacing: 0.2,
    );
  }

  static TextStyle bodySmallSemibold({Color? color}) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: color,
      letterSpacing: 0.2,
    );
  }

  static TextStyle bodySmallMedium({Color? color}) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color,
      letterSpacing: 0.2,
    );
  }

  static TextStyle bodySmallRegular({Color? color}) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: color,
      letterSpacing: 0.2,
    );
  }

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
