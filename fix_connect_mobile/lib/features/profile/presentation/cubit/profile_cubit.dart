import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/entities/user_entity.dart';
import 'package:fix_connect_mobile/features/profile/domain/usecases/get_me_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── States ────────────────────────────────────────────────────────────────────

sealed class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.user);

  final UserEntity user;
}

class ProfileError extends ProfileState {
  const ProfileError(this.message);

  final String message;
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._getMeUseCase) : super(const ProfileInitial());

  final GetMeUseCase _getMeUseCase;

  Future<void> fetchProfile() async {
    emit(const ProfileLoading());
    final result = await _getMeUseCase();
    switch (result) {
      case Ok(:final value):
        emit(ProfileLoaded(value));
      case Err(:final failure):
        emit(ProfileError(failure.message));
    }
  }
}
