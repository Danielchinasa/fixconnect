import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/profile/data/models/my_review.dart';

abstract interface class ReviewsRepository {
  Future<Result<List<MyReview>>> getMyReviews();
}
