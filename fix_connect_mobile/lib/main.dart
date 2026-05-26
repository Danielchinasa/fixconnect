import 'package:fix_connect_mobile/app/app.dart';
import 'package:fix_connect_mobile/app/theme/theme_cubit.dart';
import 'package:fix_connect_mobile/core/di/injection_container.dart';
import 'package:fix_connect_mobile/core/network/api_client.dart';
import 'package:fix_connect_mobile/core/network/token_storage.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  // Create AuthCubit here so we can hand its logOut callback to ApiClient
  // before the widget tree starts. ApiClient calls it when token refresh fails.
  final authCubit = AuthCubit(sl<TokenStorage>());
  sl<ApiClient>().onSessionExpired = authCubit.logOut;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider.value(value: authCubit),
      ],
      child: const MyApp(),
    ),
  );
}
