import 'package:fix_connect_mobile/core/errors/result.dart';

abstract interface class ArtisanSetupRepository {
  /// Creates the artisan profile. Returns the artisan ID on success.
  Future<Result<String>> createProfile({
    required String specialty,
    required String bio,
    required String location,
    required int startingPrice,
    required String responseTime,
    required Map<String, String?> weeklySchedule,
  });

  /// Sets the service categories for the artisan.
  Future<Result<void>> setCategories(List<String> categoryIds);
}
