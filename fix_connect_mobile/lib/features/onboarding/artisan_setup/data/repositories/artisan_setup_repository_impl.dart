import 'package:fix_connect_mobile/core/errors/exceptions.dart';
import 'package:fix_connect_mobile/core/errors/failures.dart';
import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/onboarding/artisan_setup/data/datasources/artisan_setup_remote_datasource.dart';
import 'package:fix_connect_mobile/features/onboarding/artisan_setup/domain/repositories/artisan_setup_repository.dart';

class ArtisanSetupRepositoryImpl implements ArtisanSetupRepository {
  const ArtisanSetupRepositoryImpl(this._remoteDataSource);

  final ArtisanSetupRemoteDataSource _remoteDataSource;

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
  Future<Result<String>> createProfile({
    required String specialty,
    required String bio,
    required String location,
    required int startingPrice,
    required String responseTime,
    required Map<String, String?> weeklySchedule,
  }) => _safeCall(
    () => _remoteDataSource.createArtisanProfile({
      'specialty': specialty,
      'bio': bio,
      'location': location,
      'startingPrice': startingPrice,
      'responseTime': responseTime,
      'weeklySchedule': weeklySchedule,
      'isOnline': true,
    }),
  );

  @override
  Future<Result<void>> setCategories(List<String> categoryIds) =>
      _safeCall(() => _remoteDataSource.setArtisanCategories(categoryIds));
}
