import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';

abstract interface class ServicesRepository {
  Future<Result<List<ServiceCategoryModel>>> getCategories();
}
