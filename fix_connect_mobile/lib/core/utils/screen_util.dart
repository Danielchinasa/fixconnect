import 'package:flutter/material.dart';

class ScreenUtil {
  // Initialize screen dimensions
  static late double width;
  static late double height;
  static late double shortestSide;

  static void init(BuildContext context) {
    // Get screen dimensions from MediaQuery
    final mediaQuery = MediaQuery.of(context);
    width = mediaQuery.size.width;
    height = mediaQuery.size.height;
    shortestSide = mediaQuery.size.shortestSide;
  }

  // Determine device type based on shortest side
  static bool get isMobile => shortestSide < 600;
  static bool get isTablet => shortestSide >= 600 && shortestSide < 900;
  static bool get isDesktop => shortestSide >= 900;
}
