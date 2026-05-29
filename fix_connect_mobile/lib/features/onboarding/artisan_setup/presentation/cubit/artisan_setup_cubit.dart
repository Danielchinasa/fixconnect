import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/onboarding/artisan_setup/domain/repositories/artisan_setup_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── States ────────────────────────────────────────────────────────────────────

sealed class ArtisanSetupState {
  const ArtisanSetupState();
}

class ArtisanSetupInitial extends ArtisanSetupState {
  const ArtisanSetupInitial();
}

class ArtisanSetupLoading extends ArtisanSetupState {
  const ArtisanSetupLoading();
}

/// Emitted when the artisan profile was created successfully.
/// Carries the new [artisanId] so the page can advance to step 2.
class ArtisanSetupProfileCreated extends ArtisanSetupState {
  const ArtisanSetupProfileCreated(this.artisanId);
  final String artisanId;
}

/// Emitted when categories are set — the wizard is fully complete.
class ArtisanSetupComplete extends ArtisanSetupState {
  const ArtisanSetupComplete();
}

class ArtisanSetupError extends ArtisanSetupState {
  const ArtisanSetupError(this.message);
  final String message;
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class ArtisanSetupCubit extends Cubit<ArtisanSetupState> {
  ArtisanSetupCubit(this._repository) : super(const ArtisanSetupInitial());

  final ArtisanSetupRepository _repository;

  Future<void> createProfile({
    required String specialty,
    required String bio,
    required String location,
    required int startingPrice,
    required String responseTime,
    required Map<String, String?> weeklySchedule,
  }) async {
    emit(const ArtisanSetupLoading());
    final result = await _repository.createProfile(
      specialty: specialty,
      bio: bio,
      location: location,
      startingPrice: startingPrice,
      responseTime: responseTime,
      weeklySchedule: weeklySchedule,
    );
    switch (result) {
      case Ok(:final value):
        emit(ArtisanSetupProfileCreated(value));
      case Err(:final failure):
        emit(ArtisanSetupError(failure.message));
    }
  }

  Future<void> setCategories(List<String> categoryIds) async {
    emit(const ArtisanSetupLoading());
    final result = await _repository.setCategories(categoryIds);
    switch (result) {
      case Ok():
        emit(const ArtisanSetupComplete());
      case Err(:final failure):
        emit(ArtisanSetupError(failure.message));
    }
  }
}
