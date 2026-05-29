import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/domain/repositories/artisans_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── States ────────────────────────────────────────────────────────────────────

sealed class MyArtisanProfileState {
  const MyArtisanProfileState();
}

class MyArtisanProfileInitial extends MyArtisanProfileState {
  const MyArtisanProfileInitial();
}

class MyArtisanProfileLoading extends MyArtisanProfileState {
  const MyArtisanProfileLoading();
}

class MyArtisanProfileLoaded extends MyArtisanProfileState {
  const MyArtisanProfileLoaded(this.artisan);
  final ArtisanModel artisan;
}

class MyArtisanProfileError extends MyArtisanProfileState {
  const MyArtisanProfileError(this.message);
  final String message;
}

class MyArtisanProfileUpdating extends MyArtisanProfileState {
  const MyArtisanProfileUpdating(this.artisan);
  final ArtisanModel artisan;
}

class MyArtisanProfileUpdateSuccess extends MyArtisanProfileState {
  const MyArtisanProfileUpdateSuccess(this.artisan);
  final ArtisanModel artisan;
}

class MyArtisanProfileUpdateError extends MyArtisanProfileState {
  const MyArtisanProfileUpdateError(this.artisan, this.message);
  final ArtisanModel artisan;
  final String message;
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class MyArtisanProfileCubit extends Cubit<MyArtisanProfileState> {
  MyArtisanProfileCubit(this._repository)
    : super(const MyArtisanProfileInitial());

  final ArtisansRepository _repository;

  Future<void> load() async {
    emit(const MyArtisanProfileLoading());
    final result = await _repository.getMyProfile();
    switch (result) {
      case Ok(:final value):
        emit(MyArtisanProfileLoaded(value));
      case Err(:final failure):
        emit(MyArtisanProfileError(failure.message));
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final current = _currentArtisan;
    if (current == null) return;
    emit(MyArtisanProfileUpdating(current));
    final result = await _repository.updateMyProfile(data);
    switch (result) {
      case Ok(:final value):
        emit(MyArtisanProfileUpdateSuccess(value));
      case Err(:final failure):
        emit(MyArtisanProfileUpdateError(current, failure.message));
    }
  }

  Future<void> updateCategories(List<String> categoryIds) async {
    final current = _currentArtisan;
    if (current == null) return;
    emit(MyArtisanProfileUpdating(current));
    final result = await _repository.updateMyCategories(categoryIds);
    switch (result) {
      case Ok():
        // Re-fetch to get updated categories from server.
        await load();
      case Err(:final failure):
        emit(MyArtisanProfileUpdateError(current, failure.message));
    }
  }

  ArtisanModel? get _currentArtisan {
    final s = state;
    return switch (s) {
      MyArtisanProfileLoaded(:final artisan) => artisan,
      MyArtisanProfileUpdating(:final artisan) => artisan,
      MyArtisanProfileUpdateSuccess(:final artisan) => artisan,
      MyArtisanProfileUpdateError(:final artisan) => artisan,
      _ => null,
    };
  }
}
