import 'package:fix_connect_mobile/core/constants/api_constants.dart';
import 'package:fix_connect_mobile/core/network/api_client.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';

abstract interface class ServicesRemoteDataSource {
  /// Fetches all active service categories from GET /service-categories.
  Future<List<ServiceCategoryModel>> getCategories();
}

class ServicesRemoteDataSourceImpl implements ServicesRemoteDataSource {
  const ServicesRemoteDataSourceImpl(this._api);

  final ApiClient _api;

  @override
  Future<List<ServiceCategoryModel>> getCategories() async {
    final response = await _api.get<List<dynamic>>(
      ApiConstants.serviceCategories,
    );
    return (response.data ?? [])
        .cast<Map<String, dynamic>>()
        .map(ServiceCategoryModel.fromJson)
        .toList();
  }
}
