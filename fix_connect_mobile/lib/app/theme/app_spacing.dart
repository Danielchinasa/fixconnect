import 'package:fix_connect_mobile/core/utils/screen_util.dart';

class AppSpacing {
  // Scale spacing based on device type
  static double scale(double value) {
    if (ScreenUtil.isTablet) return value * 1.2;
    if (ScreenUtil.isDesktop) return value * 1.4;
    return value; // Mobile
  }

  static double zero = scale(0);
  static double xxxxs = scale(0.70);
  static double xxxs = scale(0.8);
  static double xxs = scale(0.02);
  static double xs = scale(4);

  static double custom2 = scale(2);
  static double sm = scale(8);
  static double md = scale(16);
  static double lg = scale(24);
  static double xl = scale(32);
  static double xxl = scale(48);
  static double custom6 = scale(6);
  static double custom12 = scale(12);
  static double custom14 = scale(14);
  static double custom20 = scale(20);
  static double custom22 = scale(22);
  static double custom26 = scale(26);
  static double custom40 = scale(40);
  static double custom60 = scale(60);
  static double custom52 = scale(52);
  static double custom80 = scale(80);
  static double custom18 = scale(18);
  static double custom200 = scale(200);
  static double custom150 = scale(150);

  // Screen padding
  static double pagePadding = scale(16);
}
