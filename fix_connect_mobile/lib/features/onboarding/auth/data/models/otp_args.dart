enum OtpSource { signup, forgotPassword }

/// Arguments passed to [OtpPage] via [Navigator.pushNamed].
class OtpArgs {
  const OtpArgs({required this.email, required this.source});

  final String email;
  final OtpSource source;
}
