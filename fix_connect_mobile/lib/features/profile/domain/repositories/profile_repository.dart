import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/entities/user_entity.dart';

abstract interface class ProfileRepository {
  Future<Result<UserEntity>> getMe();
}
