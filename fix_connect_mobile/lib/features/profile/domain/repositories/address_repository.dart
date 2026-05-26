import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/profile/data/models/saved_address.dart';

abstract interface class AddressRepository {
  Future<Result<List<SavedAddress>>> getAddresses();
  Future<Result<(SavedAddress, String)>> createAddress({
    required String label,
    required String address,
    required String city,
    required String state,
    bool isDefault,
  });
  Future<Result<(SavedAddress, String)>> updateAddress(
    String id, {
    String? label,
    String? address,
    String? city,
    String? state,
  });
  Future<Result<String>> deleteAddress(String id);
  Future<Result<String>> setDefaultAddress(String id);
}
