import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/domain/repositories/artisans_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── States ────────────────────────────────────────────────────────────────────

sealed class CategoryArtisansState {}

class CategoryArtisansInitial extends CategoryArtisansState {}

class CategoryArtisansLoading extends CategoryArtisansState {}

class CategoryArtisansLoaded extends CategoryArtisansState {
  CategoryArtisansLoaded(this.artisans);
  final List<ArtisanModel> artisans;
}

class CategoryArtisansError extends CategoryArtisansState {
  CategoryArtisansError(this.message);
  final String message;
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class CategoryArtisansCubit extends Cubit<CategoryArtisansState> {
  CategoryArtisansCubit(this._repo) : super(CategoryArtisansInitial());

  final ArtisansRepository _repo;

  Future<void> load(String categoryId) async {
    emit(CategoryArtisansLoading());
    final result = await _repo.getByCategory(categoryId);
    switch (result) {
      case Ok(:final value):
        emit(CategoryArtisansLoaded(value));
      case Err(:final failure):
        emit(CategoryArtisansError(failure.message));
    }
  }
}
