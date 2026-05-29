import 'package:fix_connect_mobile/core/constants/api_constants.dart';
import 'package:fix_connect_mobile/core/errors/exceptions.dart';
import 'package:fix_connect_mobile/core/network/api_client.dart';

abstract interface class ArtisanSetupRemoteDataSource {
  /// POST /artisans — creates the artisan profile, returns the new artisan ID.
  Future<String> createArtisanProfile(Map<String, dynamic> body);

  /// PUT /artisans/categories — sets the artisan's service categories.
  Future<void> setArtisanCategories(List<String> categoryIds);
}

class ArtisanSetupRemoteDataSourceImpl implements ArtisanSetupRemoteDataSource {
  const ArtisanSetupRemoteDataSourceImpl(this._api);

  final ApiClient _api;

  @override
  Future<String> createArtisanProfile(Map<String, dynamic> body) async {
    final response = await _api.post<Map<String, dynamic>>(
      ApiConstants.artisans,
      data: body,
    );
    final data = response.data;
    if (data == null) {
      throw const ServerException(message: 'Empty response from server');
    }
    final id = data['id'] as String? ?? data['_id'] as String?;
    if (id == null) {
      throw const ServerException(
        message: 'Invalid response: missing artisan id',
      );
    }
    return id;
  }

  @override
  Future<void> setArtisanCategories(List<String> categoryIds) async {
    await _api.put<dynamic>(
      ApiConstants.artisanCategories,
      data: {'categoryIds': categoryIds},
    );
  }
}
