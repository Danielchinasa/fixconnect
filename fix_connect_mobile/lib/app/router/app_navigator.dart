import 'package:flutter/material.dart';

/// Holds the single [GlobalKey<NavigatorState>] for the root [MaterialApp].
/// Used only by the auth [BlocListener] in [MyApp] for state-driven navigation.
/// All other navigation uses [Navigator.of(context)] directly.
class AppNavigator {
  AppNavigator._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}
