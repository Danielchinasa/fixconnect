import 'package:fix_connect_mobile/core/errors/exceptions.dart';
import 'package:fix_connect_mobile/core/errors/failures.dart';
import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/home/data/datasources/artisans_remote_datasource.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/domain/repositories/artisans_repository.dart';

class ArtisansRepositoryImpl implements ArtisansRepository {
  const ArtisansRepositoryImpl(this._remoteDataSource);

  final ArtisansRemoteDataSource _remoteDataSource;

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
  Future<Result<List<ArtisanModel>>> getFeatured() =>
      _safeCall(() => _remoteDataSource.getFeatured());

  @override
  Future<Result<ArtisanModel>> getById(String id) =>
      _safeCall(() => _remoteDataSource.getById(id));

  @override
  Future<Result<ArtisanModel>> getMyProfile() =>
      _safeCall(() => _remoteDataSource.getMyProfile());

  @override
  Future<Result<ArtisanModel>> updateMyProfile(Map<String, dynamic> data) =>
      _safeCall(() => _remoteDataSource.updateMyProfile(data));

  @override
  Future<Result<void>> updateMyCategories(List<String> categoryIds) =>
      _safeCall(() => _remoteDataSource.updateMyCategories(categoryIds));

  @override
  Future<Result<List<ArtisanModel>>> getByCategory(String categoryId) =>
      _safeCall(() => _remoteDataSource.getByCategory(categoryId));
}
