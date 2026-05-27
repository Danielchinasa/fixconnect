import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/entities/user_entity.dart';

abstract interface class ProfileRepository {
  Future<Result<UserEntity>> getMe();

  Future<Result<UserEntity>> updateProfile({
    String? firstName,
    String? lastName,
    String? bio,
    String? city,
    String? gender,
    String? dateOfBirth,
  });

  Future<Result<String>> uploadAvatar({required String filePath});
}
