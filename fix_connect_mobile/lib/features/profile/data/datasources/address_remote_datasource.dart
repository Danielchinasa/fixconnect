import 'package:fix_connect_mobile/core/constants/api_constants.dart';
import 'package:fix_connect_mobile/core/network/api_client.dart';
import 'package:fix_connect_mobile/features/profile/data/models/saved_address.dart';

abstract interface class AddressRemoteDataSource {
  Future<List<SavedAddress>> getAddresses();
  Future<(SavedAddress, String)> createAddress({
    required String label,
    required String address,
    required String city,
    required String state,
    bool isDefault,
  });
  Future<(SavedAddress, String)> updateAddress(
    String id, {
    String? label,
    String? address,
    String? city,
    String? state,
  });
  Future<String> deleteAddress(String id);
  Future<String> setDefaultAddress(String id);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  const AddressRemoteDataSourceImpl(this._api);

  final ApiClient _api;

  @override
  Future<List<SavedAddress>> getAddresses() async {
    final response = await _api.get<List<dynamic>>(ApiConstants.savedAddresses);
    return (response.data ?? [])
        .cast<Map<String, dynamic>>()
        .map(SavedAddress.fromJson)
        .toList();
  }

  @override
  Future<(SavedAddress, String)> createAddress({
    required String label,
    required String address,
    required String city,
    required String state,
    bool isDefault = false,
  }) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConstants.savedAddresses,
      data: {
        'label': label,
        'address': address,
        'city': city,
        'state': state,
        'isDefault': isDefault,
      },
    );
    final body = response.data!;
    final message = body['message'] as String? ?? 'Address saved.';
    final addressData = body['data'] as Map<String, dynamic>? ?? body;
    return (SavedAddress.fromJson(addressData), message);
  }

  @override
  Future<(SavedAddress, String)> updateAddress(
    String id, {
    String? label,
    String? address,
    String? city,
    String? state,
  }) async {
    final response = await _api.patch<Map<String, dynamic>>(
      '${ApiConstants.savedAddresses}/$id',
      data: {
        if (label != null) 'label': label,
        if (address != null) 'address': address,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
      },
    );
    final body = response.data!;
    final message = body['message'] as String? ?? 'Address updated.';
    final addressData = body['data'] as Map<String, dynamic>? ?? body;
    return (SavedAddress.fromJson(addressData), message);
  }

  @override
  Future<String> deleteAddress(String id) async {
    final response = await _api.delete<Map<String, dynamic>>(
      '${ApiConstants.savedAddresses}/$id',
    );
    return response.data?['message'] as String? ?? 'Address removed.';
  }

  @override
  Future<String> setDefaultAddress(String id) async {
    final response = await _api.patch<Map<String, dynamic>>(
      '${ApiConstants.savedAddresses}/$id/set-default',
    );
    return response.data?['message'] as String? ?? 'Default address updated.';
  }
}
