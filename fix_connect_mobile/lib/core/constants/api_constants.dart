import 'dart:io' show Platform;

/// All API base URLs and endpoint path constants.
/// Swap [baseUrl] per environment via a build flavor or --dart-define.
// ignore: avoid_classes_with_only_static_members
class ApiConstants {
  // ── Base ────────────────────────────────────────────────────────────────────
  // Priority order:
  //   1. --dart-define=BASE_URL=<url>  (always wins — use for production / CI)
  //   2. Auto-detect at runtime:
  //        Android emulator  → 10.0.2.2  (emulator's built-in alias for the host Mac)
  //        iOS Simulator     → localhost  (shares the Mac's network stack)
  //        Physical device   → pass BASE_URL manually with the Mac's LAN IP
  static String get baseUrl {
    // ignore: do_not_use_environment
    const envUrl = String.fromEnvironment('BASE_URL');
    if (envUrl.isNotEmpty) return envUrl;

    // Detect the platform at runtime so developers don't have to remember
    // to pass --dart-define when switching between emulator and simulator.
    // 10.0.2.2 is the Android emulator's special alias for the host machine.
    // Plain "localhost" inside the emulator resolves to the emulator itself.
    final host = _Platform.isAndroid ? '10.0.2.2' : 'localhost';
    return 'http://$host:3000/api/v1';
  }

  // ── Auth ────────────────────────────────────────────────────────────────────
  static const login = '/auth/login';
  static const signup = '/auth/signup';
  static const verifyOtp = '/auth/otp/verify-email';
  static const sendOtp = '/auth/otp/send';
  static const resendOtp = '/auth/resend-otp';
  static const forgotPassword = '/auth/forgot-password';
  static const resetPassword = '/auth/reset-password';
  static const refreshToken = '/auth/refresh';
  static const logout = '/auth/logout';
  static const me = '/auth/me';

  // ── Profile ─────────────────────────────────────────────────────────────────
  static const profile = '/profile';
  static const savedAddresses = '/saved-addresses';

  // ── Bookings ────────────────────────────────────────────────────────────────
  static const bookings = '/bookings';

  // ── Services ────────────────────────────────────────────────────────────────
  static const services = '/services';
  static const serviceCategories = '/service-categories';

  // ── Artisans ────────────────────────────────────────────────────────────────
  static const artisans = '/artisans';
  static const artisanCategories = '/artisans/categories';
  static const featuredArtisans = '/artisans/featured';

  // ── Notifications ───────────────────────────────────────────────────────────
  static const notifications = '/notifications';
}

/// Thin wrapper so [ApiConstants] can read [Platform] without coupling the
/// test suite to dart:io directly.
class _Platform {
  static bool get isAndroid => Platform.isAndroid;
}
