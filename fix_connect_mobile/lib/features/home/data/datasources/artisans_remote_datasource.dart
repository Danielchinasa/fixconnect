import 'package:fix_connect_mobile/core/constants/api_constants.dart';
import 'package:fix_connect_mobile/core/errors/exceptions.dart';
import 'package:fix_connect_mobile/core/network/api_client.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';

abstract interface class ArtisansRemoteDataSource {
  /// Returns the list of featured artisans from [ApiConstants.featuredArtisans].
  Future<List<ArtisanModel>> getFeatured();

  /// Returns the full artisan profile for [id] from GET /artisans/:id.
  Future<ArtisanModel> getById(String id);

  /// Returns the authenticated artisan's own profile from GET /artisans/me.
  Future<ArtisanModel> getMyProfile();

  /// Updates the authenticated artisan's profile via PATCH /artisans.
  Future<ArtisanModel> updateMyProfile(Map<String, dynamic> data);

  /// Replaces the authenticated artisan's categories via PUT /artisans/categories.
  Future<void> updateMyCategories(List<String> categoryIds);

  /// Returns artisans that belong to the given [categoryId] via GET /artisans?categoryId=.
  Future<List<ArtisanModel>> getByCategory(String categoryId);
}

class ArtisansRemoteDataSourceImpl implements ArtisansRemoteDataSource {
  const ArtisansRemoteDataSourceImpl(this._api);

  final ApiClient _api;

  @override
  Future<List<ArtisanModel>> getFeatured() async {
    final response = await _api.get<dynamic>(ApiConstants.featuredArtisans);

    final body = response.data;
    if (body == null) return [];

    List<dynamic> items;
    if (body is List) {
      items = body;
    } else if (body is Map<String, dynamic>) {
      // Handle paginated envelope: { data: [...] } or { artisans: [...] }
      final inner = body['data'] ?? body['artisans'];
      if (inner is List) {
        items = inner;
      } else {
        throw const ServerException(
          message: 'Unexpected featured artisans response shape',
        );
      }
    } else {
      throw const ServerException(
        message: 'Unexpected featured artisans response type',
      );
    }

    return items
        .whereType<Map<String, dynamic>>()
        .map(ArtisanModel.fromJson)
        .toList();
  }

  @override
  Future<ArtisanModel> getById(String id) async {
    final response = await _api.get<Map<String, dynamic>>(
      '${ApiConstants.artisans}/$id',
    );
    final data = response.data;
    if (data == null) {
      throw const ServerException(message: 'Artisan not found');
    }
    return ArtisanModel.fromJson(data);
  }

  @override
  Future<ArtisanModel> getMyProfile() async {
    final response = await _api.get<Map<String, dynamic>>(
      '${ApiConstants.artisans}/me',
    );
    final data = response.data;
    if (data == null) throw const ServerException(message: 'Profile not found');
    return ArtisanModel.fromJson(data);
  }

  @override
  Future<ArtisanModel> updateMyProfile(Map<String, dynamic> data) async {
    final response = await _api.patch<Map<String, dynamic>>(
      ApiConstants.artisans,
      data: data,
    );
    final body = response.data;
    if (body == null) throw const ServerException(message: 'Empty response');
    return ArtisanModel.fromJson(body);
  }

  @override
  Future<void> updateMyCategories(List<String> categoryIds) async {
    await _api.put<dynamic>(
      ApiConstants.artisanCategories,
      data: {'categoryIds': categoryIds},
    );
  }

  @override
  Future<List<ArtisanModel>> getByCategory(String categoryId) async {
    final response = await _api.get<dynamic>(
      ApiConstants.artisans,
      queryParameters: {'categoryId': categoryId},
    );
    final body = response.data;
    if (body == null) return [];
    List<dynamic> items;
    if (body is List) {
      items = body;
    } else if (body is Map<String, dynamic>) {
      final inner = body['data'] ?? body['artisans'];
      items = inner is List ? inner : [];
    } else {
      return [];
    }
    return items
        .whereType<Map<String, dynamic>>()
        .map(ArtisanModel.fromJson)
        .toList();
  }
}
