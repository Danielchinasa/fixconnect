import 'package:fix_connect_mobile/app/router/app_navigator.dart';
import 'package:fix_connect_mobile/app/router/app_router.dart';
import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/core/utils/screen_util.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme/app_theme.dart';
import 'theme/theme_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil to get the screen dimensions
    ScreenUtil.init(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        final nav = AppNavigator.navigatorKey.currentState;
        if (nav == null) return;
        if (state is AuthAuthenticated) {
          nav.pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
        } else if (state is AuthUnauthenticated) {
          nav.pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
        }
      },
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Fix Connect',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            initialRoute: AppRoutes.onboarding,
            onGenerateRoute: RouteGenerator.generateRoute,
            navigatorKey: AppNavigator.navigatorKey,
          );
        },
      ),
    );
  }
}
