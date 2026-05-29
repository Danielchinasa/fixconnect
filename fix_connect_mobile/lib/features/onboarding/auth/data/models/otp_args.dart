import 'package:fix_connect_mobile/features/onboarding/auth/domain/entities/user_entity.dart';

enum OtpSource { signup, forgotPassword }

/// Arguments passed to [OtpPage] via [Navigator.pushNamed].
class OtpArgs {
  const OtpArgs({required this.email, required this.source, this.role});

  final String email;
  final OtpSource source;

  /// Role chosen during signup. Only set when [source] is [OtpSource.signup].
  /// Used to redirect artisans to the profile setup wizard after OTP verification.
  final UserRole? role;
}
