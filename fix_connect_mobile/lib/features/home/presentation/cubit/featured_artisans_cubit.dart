import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/domain/repositories/artisans_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── States ──────────────────────────────────────────────────────────────────

sealed class FeaturedArtisansCubitState {
  const FeaturedArtisansCubitState();
}

class FeaturedArtisansInitial extends FeaturedArtisansCubitState {
  const FeaturedArtisansInitial();
}

class FeaturedArtisansLoading extends FeaturedArtisansCubitState {
  const FeaturedArtisansLoading();
}

class FeaturedArtisansLoaded extends FeaturedArtisansCubitState {
  final List<ArtisanModel> artisans;
  const FeaturedArtisansLoaded(this.artisans);
}

class FeaturedArtisansError extends FeaturedArtisansCubitState {
  final String message;
  const FeaturedArtisansError(this.message);
}

// ── Cubit ────────────────────────────────────────────────────────────────────

class FeaturedArtisansCubit extends Cubit<FeaturedArtisansCubitState> {
  FeaturedArtisansCubit(this._repository)
    : super(const FeaturedArtisansInitial());

  final ArtisansRepository _repository;

  Future<void> load() async {
    emit(const FeaturedArtisansLoading());
    final result = await _repository.getFeatured();
    switch (result) {
      case Ok(:final value):
        emit(FeaturedArtisansLoaded(value));
      case Err(:final failure):
        emit(FeaturedArtisansError(failure.message));
    }
  }
}
