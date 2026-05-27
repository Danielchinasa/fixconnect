import 'package:fix_connect_mobile/core/errors/exceptions.dart';
import 'package:fix_connect_mobile/core/errors/failures.dart';
import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/entities/user_entity.dart';
import 'package:fix_connect_mobile/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:fix_connect_mobile/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  Future<Result<T>> _safeCall<T>(Future<T> Function() call) async {
    try {
      return Ok(await call());
    } on UnauthorizedException {
      return const Err(UnauthorizedFailure());
    } on ServerException catch (e) {
      return Err(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Err(NetworkFailure(e.message));
    } catch (e) {
      return Err(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> getMe() =>
      _safeCall(() => _remoteDataSource.getMe());

  @override
  Future<Result<UserEntity>> updateProfile({
    String? firstName,
    String? lastName,
    String? bio,
    String? city,
    String? gender,
    String? dateOfBirth,
  }) {
    return _safeCall(
      () => _remoteDataSource.updateProfile(
        firstName: firstName,
        lastName: lastName,
        bio: bio,
        city: city,
        gender: gender,
        dateOfBirth: dateOfBirth,
      ),
    );
  }

  @override
  Future<Result<String>> uploadAvatar({required String filePath}) {
    return _safeCall(() => _remoteDataSource.uploadAvatar(filePath: filePath));
  }
}
