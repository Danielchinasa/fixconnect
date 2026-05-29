import 'package:fix_connect_mobile/core/errors/exceptions.dart';
import 'package:fix_connect_mobile/core/errors/failures.dart';
import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/home/data/datasources/services_remote_datasource.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:fix_connect_mobile/features/home/domain/repositories/services_repository.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  const ServicesRepositoryImpl(this._remoteDataSource);

  final ServicesRemoteDataSource _remoteDataSource;

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
  Future<Result<List<ServiceCategoryModel>>> getCategories() =>
      _safeCall(() => _remoteDataSource.getCategories());
}
