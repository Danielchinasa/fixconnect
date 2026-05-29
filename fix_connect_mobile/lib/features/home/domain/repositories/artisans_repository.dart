import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';

abstract interface class ArtisansRepository {
  Future<Result<List<ArtisanModel>>> getFeatured();
  Future<Result<ArtisanModel>> getById(String id);
  Future<Result<ArtisanModel>> getMyProfile();
  Future<Result<ArtisanModel>> updateMyProfile(Map<String, dynamic> data);
  Future<Result<void>> updateMyCategories(List<String> categoryIds);
  Future<Result<List<ArtisanModel>>> getByCategory(String categoryId);
}
