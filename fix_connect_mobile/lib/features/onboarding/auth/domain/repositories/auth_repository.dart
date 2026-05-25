import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/entities/user_entity.dart';

/// Contract for all auth operations. Implemented in the data layer.
abstract interface class AuthRepository {
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Result<void>> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  });

  /// [purpose] is either "signup" or "forgot_password".
  Future<Result<UserEntity>> verifyOtp({
    required String email,
    required String otp,
    required String purpose,
  });

  Future<Result<void>> resendOtp({
    required String email,
    required String purpose,
  });

  Future<Result<void>> forgotPassword({required String email});

  Future<Result<void>> resetPassword({
    required String email,
    required String newPassword,
  });

  Future<void> logout();
}
