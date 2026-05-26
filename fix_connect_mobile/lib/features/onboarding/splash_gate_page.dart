import 'package:fix_connect_mobile/features/onboarding/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Entry point of the app.
/// Calls [AuthCubit.init] to restore any existing session.
/// Navigation is handled by the root [BlocListener] in [MyApp].
class SplashGatePage extends StatefulWidget {
  const SplashGatePage({super.key});

  @override
  State<SplashGatePage> createState() => _SplashGatePageState();
}

class _SplashGatePageState extends State<SplashGatePage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
