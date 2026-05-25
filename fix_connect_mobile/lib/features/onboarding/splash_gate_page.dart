import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/core/utils/onboarding_prefs.dart';
import 'package:flutter/material.dart';

/// Entry point of the app.
/// Reads the onboarding flag and immediately redirects —
/// users never see this page for more than a frame.
class SplashGatePage extends StatefulWidget {
  const SplashGatePage({super.key});

  @override
  State<SplashGatePage> createState() => _SplashGatePageState();
}

class _SplashGatePageState extends State<SplashGatePage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    final seen = await OnboardingPrefs.hasSeenOnboarding();
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacementNamed(seen ? AppRoutes.login : AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SizedBox.shrink());
  }
}
