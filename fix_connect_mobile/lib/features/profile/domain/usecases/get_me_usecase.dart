import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/entities/user_entity.dart';
import 'package:fix_connect_mobile/features/profile/domain/repositories/profile_repository.dart';

class GetMeUseCase {
  const GetMeUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<UserEntity>> call() => _repository.getMe();
}
