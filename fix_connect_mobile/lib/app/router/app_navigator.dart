import 'package:flutter/material.dart';

class AppNavigator {
  AppNavigator._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static NavigatorState get _navigator => navigatorKey.currentState!;

  // ✅ PUSH
  static Future<void> push(String routeName, {Object? arguments}) {
    return _navigator.pushNamed(routeName, arguments: arguments);
  }

  // ✅ PUSH REPLACEMENT (THIS FIXES YOUR ERROR)
  static Future<void> pushReplacement(String routeName, {Object? arguments}) {
    return _navigator.pushReplacementNamed(routeName, arguments: arguments);
  }

  // ✅ POP
  static void pop<T extends Object?>([T? result]) {
    _navigator.pop(result);
  }
}
