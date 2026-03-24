import 'package:fix_connect_mobile/core/utils/screen_util.dart';

class AppSpacing {
  // Scale spacing based on device type
  static double scale(double value) {
    if (ScreenUtil.isTablet) return value * 1.2;
    if (ScreenUtil.isDesktop) return value * 1.4;
    return value; // Mobile
  }

  static double custom0 = scale(0);
  static double custom2 = scale(2);
  static double custom4 = scale(4);
  static double custom6 = scale(6);
  static double custom8 = scale(8);
  static double custom10 = scale(10);
  static double custom12 = scale(12);
  static double custom14 = scale(14);
  static double custom16 = scale(16);
  static double custom18 = scale(18);
  static double custom20 = scale(20);
  static double custom22 = scale(22);
  static double custom24 = scale(24);
  static double custom26 = scale(26);
  static double custom32 = scale(32);
  static double custom40 = scale(40);
  static double custom48 = scale(48);
  static double custom52 = scale(52);
  static double custom60 = scale(60);
  static double custom80 = scale(80);
  static double custom150 = scale(150);
  static double custom200 = scale(200);
}
