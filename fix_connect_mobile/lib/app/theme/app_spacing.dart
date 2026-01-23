import 'package:fix_connect_mobile/core/utils/screen_util.dart';

class AppSpacing {
  // Scale spacing based on device type
  static double scale(double value) {
    if (ScreenUtil.isTablet) return value * 1.2;
    if (ScreenUtil.isDesktop) return value * 1.4;
    return value; // Mobile
  }

  static double xxxxs = scale(0.70);
  static double xxxs = scale(0.8);
  static double xxs = scale(0.02);
  static double xs = scale(4);
  static double sm = scale(8);
  static double md = scale(16);
  static double lg = scale(24);
  static double xl = scale(32);
  static double xxl = scale(48);

  // Screen padding
  static double pagePadding = scale(16);
}
