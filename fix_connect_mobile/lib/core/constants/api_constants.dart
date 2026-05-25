/// All API base URLs and endpoint path constants.
/// Swap [baseUrl] per environment via a build flavor or --dart-define.
class ApiConstants {
  // ── Base ────────────────────────────────────────────────────────────────────
  static const baseUrl = 'https://api.fixconnect.app/v1';

  // ── Auth ────────────────────────────────────────────────────────────────────
  static const login = '/auth/login';
  static const signup = '/auth/signup';
  static const verifyOtp = '/auth/verify-otp';
  static const resendOtp = '/auth/resend-otp';
  static const forgotPassword = '/auth/forgot-password';
  static const resetPassword = '/auth/reset-password';
  static const refreshToken = '/auth/refresh';
  static const logout = '/auth/logout';

  // ── Profile ─────────────────────────────────────────────────────────────────
  static const profile = '/profile';

  // ── Bookings ────────────────────────────────────────────────────────────────
  static const bookings = '/bookings';

  // ── Services ────────────────────────────────────────────────────────────────
  static const services = '/services';

  // ── Notifications ───────────────────────────────────────────────────────────
  static const notifications = '/notifications';
}
