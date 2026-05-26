import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/entities/user_entity.dart';

/// Contract for all auth operations. Implemented in the data layer.
abstract interface class AuthRepository {
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Result<void>> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    String role = 'CUSTOMER',
  });

  /// Returns the verified [UserEntity] if the server includes it, otherwise null.
  Future<Result<UserEntity?>> verifyOtp({
    required String email,
    required String code,
  });

  Future<Result<void>> resendOtp({
    required String email,
    required String purpose,
  });

  Future<Result<void>> sendOtp({
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
