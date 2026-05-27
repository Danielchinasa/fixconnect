part of 'stats_cubit.dart';

abstract class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object?> get props => [];
}

class StatsInitial extends StatsState {}

class StatsLoading extends StatsState {}

class StatsLoaded extends StatsState {
  final int totalBookings;
  final int totalReviews;
  final double? avgRating;
  final int completedJobs;

  const StatsLoaded({
    required this.totalBookings,
    required this.totalReviews,
    required this.avgRating,
    required this.completedJobs,
  });

  @override
  List<Object?> get props => [
    totalBookings,
    totalReviews,
    avgRating,
    completedJobs,
  ];
}

class StatsError extends StatsState {
  final String message;

  const StatsError(this.message);

  @override
  List<Object?> get props => [message];
}
