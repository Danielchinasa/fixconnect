import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/core/utils/assets_helper.dart';
import 'package:fix_connect_mobile/features/bookings/data/models/booking_model.dart';
import 'package:fix_connect_mobile/features/bookings/presentation/pages/booking_detail_page.dart';
import 'package:fix_connect_mobile/features/bookings/presentation/pages/booking_flow_page.dart';
import 'package:fix_connect_mobile/features/bookings/presentation/pages/write_review_page.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/presentation/pages/search_results_page.dart';
import 'package:fix_connect_mobile/features/notifications/presentation/pages/notifications_page.dart';
import 'package:fix_connect_mobile/features/support/presentation/pages/help_support_page.dart';
import 'package:fix_connect_mobile/features/support/presentation/pages/terms_privacy_page.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:fix_connect_mobile/features/home/presentation/pages/artisan_profile_page.dart';
import 'package:fix_connect_mobile/features/home/presentation/pages/home_page.dart';
import 'package:fix_connect_mobile/features/home/presentation/pages/service_detail_page.dart';
import 'package:fix_connect_mobile/features/home/presentation/pages/services_all_page.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/presentation/pages/forgot_password_page.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/presentation/pages/login_page.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/presentation/pages/otp_page.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/presentation/pages/signup_page.dart';
import 'package:fix_connect_mobile/features/onboarding/carousel/data/carousel_model.dart';
import 'package:fix_connect_mobile/features/onboarding/carousel/presentation/carousel_page.dart';
import 'package:fix_connect_mobile/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:fix_connect_mobile/features/profile/presentation/pages/payment_methods_page.dart';
import 'package:fix_connect_mobile/features/profile/presentation/pages/personal_information_page.dart';
import 'package:fix_connect_mobile/features/profile/presentation/pages/saved_addresses_page.dart';
import 'package:fix_connect_mobile/features/profile/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (_) => CarouselPage(
            pages: <CarouselModel>[
              CarouselModel(
                image: ImageAssets.carouselFirst(),
                title: 'Find Trusted Experts Near You',
                description:
                    'Discover verified professionals in your area, reviewed by real customers and ready to get the job done right.',
              ),
              CarouselModel(
                image: ImageAssets.carouselSecond(),
                title: 'Work Smarter, Earn More',
                description:
                    'Get more jobs, keep track of your bookings easily, connect with clients, and earn more money your way.',
              ),
              CarouselModel(
                image: ImageAssets.carouselThird(),
                title: 'Your Money Is Safe Until the Job Is Done',
                description:
                    'Your payments are completely safe, held securely, and only released when the work is done to your satisfaction.',
              ),
            ],
          ),
        );
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case AppRoutes.otp:
        return MaterialPageRoute(builder: (_) => const OtpPage());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      case AppRoutes.home:
        final idx = settings.arguments as int?;
        return MaterialPageRoute(
          builder: (_) => HomePage(initialIndex: idx ?? 0),
        );
      case AppRoutes.artisanProfile:
        final artisan = settings.arguments as ArtisanModel;
        return MaterialPageRoute(
          builder: (_) => ArtisanProfilePage(artisan: artisan),
        );
      case AppRoutes.servicesAll:
        return MaterialPageRoute(builder: (_) => const ServicesAllPage());
      case AppRoutes.serviceDetail:
        final service = settings.arguments as ServiceCategoryModel;
        return MaterialPageRoute(
          builder: (_) => ServiceDetailPage(service: service),
        );
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case AppRoutes.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfilePage());
      case AppRoutes.personalInformation:
        return MaterialPageRoute(
          builder: (_) => const PersonalInformationPage(),
        );
      case AppRoutes.paymentMethods:
        return MaterialPageRoute(builder: (_) => const PaymentMethodsPage());
      case AppRoutes.savedAddresses:
        return MaterialPageRoute(builder: (_) => const SavedAddressesPage());
      case AppRoutes.bookingFlow:
        final artisan = settings.arguments as ArtisanModel;
        return MaterialPageRoute(
          builder: (_) => BookingFlowPage(artisan: artisan),
        );
      case AppRoutes.bookingDetail:
        final booking = settings.arguments as BookingModel;
        return MaterialPageRoute(
          builder: (_) => BookingDetailPage(booking: booking),
        );
      case AppRoutes.writeReview:
        final booking = settings.arguments as BookingModel;
        return MaterialPageRoute(
          builder: (_) => WriteReviewPage(booking: booking),
        );
      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsPage());
      case AppRoutes.searchResults:
        final query = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => SearchResultsPage(initialQuery: query),
        );
      case AppRoutes.helpSupport:
        return MaterialPageRoute(builder: (_) => const HelpSupportPage());
      case AppRoutes.termsPrivacy:
        return MaterialPageRoute(builder: (_) => const TermsPrivacyPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
