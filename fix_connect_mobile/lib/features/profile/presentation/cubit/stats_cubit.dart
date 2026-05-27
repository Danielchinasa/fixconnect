import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  final Dio _dio;

  StatsCubit(this._dio) : super(StatsInitial());

  Future<void> fetchStats() async {
    emit(StatsLoading());
    try {
      final response = await _dio.get('/users/me/stats');
      emit(
        StatsLoaded(
          totalBookings: response.data['totalBookings'] ?? 0,
          totalReviews: response.data['totalReviews'] ?? 0,
          avgRating: response.data['avgRating']?.toDouble(),
          completedJobs: response.data['completedJobs'] ?? 0,
        ),
      );
    } catch (e) {
      emit(StatsError(e.toString()));
    }
  }
}
