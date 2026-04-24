class AppRoutes {
  static const onboarding = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const otp = '/otp';
  static const forgotPassword = '/forgot-password';
  static const home = '/home';
  static const artisanProfile = '/artisan-profile';
  static const servicesAll = '/services';
  static const serviceDetail = '/service-detail';

  static String loginPage() => login;
  static String onboardingScreen() => onboarding;
  static String signUpPage() => signup;
  static String otpPage() => otp;
  static String forgotPasswordPage() => forgotPassword;
  static String homePage() => home;
  static String servicesAllPage() => servicesAll;
  static String serviceDetailPage() => serviceDetail;
}
