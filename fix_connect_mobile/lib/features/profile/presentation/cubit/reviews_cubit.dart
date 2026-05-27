import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/profile/data/models/my_review.dart';
import 'package:fix_connect_mobile/features/profile/domain/repositories/reviews_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class ReviewsState {
  const ReviewsState();
}

class ReviewsInitial extends ReviewsState {
  const ReviewsInitial();
}

class ReviewsLoading extends ReviewsState {
  const ReviewsLoading();
}

class ReviewsLoaded extends ReviewsState {
  const ReviewsLoaded(this.reviews);

  final List<MyReview> reviews;
}

class ReviewsError extends ReviewsState {
  const ReviewsError(this.message, {this.reviews = const []});

  final String message;
  final List<MyReview> reviews;
}

class ReviewsCubit extends Cubit<ReviewsState> {
  ReviewsCubit(this._repository) : super(const ReviewsInitial());

  final ReviewsRepository _repository;

  Future<void> load() async {
    emit(const ReviewsLoading());
    final result = await _repository.getMyReviews();
    switch (result) {
      case Ok(:final value):
        emit(ReviewsLoaded(value));
      case Err(:final failure):
        emit(ReviewsError(failure.message));
    }
  }
}
