import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/domain/repositories/artisans_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── States ──────────────────────────────────────────────────────────────────

sealed class ArtisanProfileState {
  const ArtisanProfileState();
}

class ArtisanProfileInitial extends ArtisanProfileState {
  const ArtisanProfileInitial();
}

class ArtisanProfileLoading extends ArtisanProfileState {
  const ArtisanProfileLoading();
}

class ArtisanProfileLoaded extends ArtisanProfileState {
  final ArtisanModel artisan;
  const ArtisanProfileLoaded(this.artisan);
}

class ArtisanProfileError extends ArtisanProfileState {
  final String message;
  const ArtisanProfileError(this.message);
}

// ── Cubit ────────────────────────────────────────────────────────────────────

class ArtisanProfileCubit extends Cubit<ArtisanProfileState> {
  ArtisanProfileCubit(this._repository) : super(const ArtisanProfileInitial());

  final ArtisansRepository _repository;

  Future<void> load(String id) async {
    emit(const ArtisanProfileLoading());
    final result = await _repository.getById(id);
    switch (result) {
      case Ok(:final value):
        emit(ArtisanProfileLoaded(value));
      case Err(:final failure):
        emit(ArtisanProfileError(failure.message));
    }
  }
}
