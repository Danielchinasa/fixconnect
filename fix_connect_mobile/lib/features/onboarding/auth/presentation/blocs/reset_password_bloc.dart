import 'package:equatable/equatable.dart';
import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/usecases/reset_password_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── Events ────────────────────────────────────────────────────────────────────

sealed class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object?> get props => [];
}

final class ResetPasswordSubmitted extends ResetPasswordEvent {
  const ResetPasswordSubmitted({
    required this.email,
    required this.newPassword,
  });

  final String email;
  final String newPassword;

  @override
  List<Object?> get props => [email];
}

// ── States ────────────────────────────────────────────────────────────────────

sealed class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object?> get props => [];
}

final class ResetPasswordInitial extends ResetPasswordState {
  const ResetPasswordInitial();
}

final class ResetPasswordLoading extends ResetPasswordState {
  const ResetPasswordLoading();
}

/// Password changed successfully. Widget should navigate to login.
final class ResetPasswordSuccess extends ResetPasswordState {
  const ResetPasswordSuccess();
}

final class ResetPasswordFailure extends ResetPasswordState {
  const ResetPasswordFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// ── BLoC ──────────────────────────────────────────────────────────────────────

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc({required ResetPasswordUseCase resetPasswordUseCase})
    : _resetPasswordUseCase = resetPasswordUseCase,
      super(const ResetPasswordInitial()) {
    on<ResetPasswordSubmitted>(_onSubmitted);
  }

  final ResetPasswordUseCase _resetPasswordUseCase;

  Future<void> _onSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(const ResetPasswordLoading());
    final result = await _resetPasswordUseCase(
      ResetPasswordParams(email: event.email, newPassword: event.newPassword),
    );
    switch (result) {
      case Ok():
        emit(const ResetPasswordSuccess());
      case Err(:final failure):
        emit(ResetPasswordFailure(failure.message));
    }
  }
}
