import 'package:fix_connect_mobile/core/utils/assets_helper.dart';
import 'package:fix_connect_mobile/core/utils/screen_util.dart';
import 'package:fix_connect_mobile/core/widgets/app_scaffold.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/presentation/pages/login_page.dart';
import 'package:fix_connect_mobile/features/onboarding/carousel/data/carousel_model.dart';
import 'package:fix_connect_mobile/features/onboarding/carousel/presentation/carousel_page.dart';
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

    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Fix Connect',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            home: CarouselPage(
              pages: <CarouselModel>[
                CarouselModel(
                  image: ImageAssets.carouselFirst(),
                  title: 'Find Trusted Experts Near You',
                  description:
                      'Discover verified professionals in your area, reviewed by real customers and ready to get the job done right.',
                ),
                CarouselModel(
                  image: ImageAssets.carouselFirst(),
                  title: 'Work Smarter, Earn More',
                  description:
                      'Get more jobs, keep track of your bookings easily, connect with clients, and earn more money your way.',
                ),
                CarouselModel(
                  image: ImageAssets.carouselFirst(),
                  title: 'Your Money Is Safe Until the Job Is Done',
                  description:
                      'Your payments are completely safe, held securely, and only released when the work is done to your satisfaction.',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
