import 'package:fix_connect_mobile/core/errors/exceptions.dart';
import 'package:fix_connect_mobile/core/errors/failures.dart';
import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/profile/data/datasources/address_remote_datasource.dart';
import 'package:fix_connect_mobile/features/profile/data/models/saved_address.dart';
import 'package:fix_connect_mobile/features/profile/domain/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  const AddressRepositoryImpl(this._remoteDataSource);

  final AddressRemoteDataSource _remoteDataSource;

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
  Future<Result<List<SavedAddress>>> getAddresses() =>
      _safeCall(() => _remoteDataSource.getAddresses());

  @override
  Future<Result<(SavedAddress, String)>> createAddress({
    required String label,
    required String address,
    required String city,
    required String state,
    bool isDefault = false,
  }) => _safeCall(
    () => _remoteDataSource.createAddress(
      label: label,
      address: address,
      city: city,
      state: state,
      isDefault: isDefault,
    ),
  );

  @override
  Future<Result<(SavedAddress, String)>> updateAddress(
    String id, {
    String? label,
    String? address,
    String? city,
    String? state,
  }) => _safeCall(
    () => _remoteDataSource.updateAddress(
      id,
      label: label,
      address: address,
      city: city,
      state: state,
    ),
  );

  @override
  Future<Result<String>> deleteAddress(String id) =>
      _safeCall(() => _remoteDataSource.deleteAddress(id));

  @override
  Future<Result<String>> setDefaultAddress(String id) =>
      _safeCall(() => _remoteDataSource.setDefaultAddress(id));
}
