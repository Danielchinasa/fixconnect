import 'package:fix_connect_mobile/core/network/api_client.dart';
import 'package:fix_connect_mobile/features/profile/data/models/my_review.dart';

abstract interface class ReviewsRemoteDataSource {
  Future<List<MyReview>> getMyReviews();
}

class ReviewsRemoteDataSourceImpl implements ReviewsRemoteDataSource {
  const ReviewsRemoteDataSourceImpl(this._api);

  final ApiClient _api;

  @override
  Future<List<MyReview>> getMyReviews() async {
    final response = await _api.get<dynamic>('/reviews/my');
    final body = response.data;

    if (body is List) {
      return body
          .whereType<Map<String, dynamic>>()
          .map(MyReview.fromJson)
          .toList();
    }

    if (body is Map<String, dynamic>) {
      final candidates = [body['data'], body['reviews'], body['items']];
      for (final c in candidates) {
        if (c is List) {
          return c
              .whereType<Map<String, dynamic>>()
              .map(MyReview.fromJson)
              .toList();
        }
      }
    }

    return const <MyReview>[];
  }
}
