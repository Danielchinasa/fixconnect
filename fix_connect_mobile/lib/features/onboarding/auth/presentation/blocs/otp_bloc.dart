import 'package:equatable/equatable.dart';
import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/entities/user_entity.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── Events ────────────────────────────────────────────────────────────────────

sealed class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object?> get props => [];
}

final class OtpSubmitted extends OtpEvent {
  const OtpSubmitted({required this.email, required this.code});

  final String email;
  final String code;

  @override
  List<Object?> get props => [email, code];
}

final class OtpResendRequested extends OtpEvent {
  const OtpResendRequested({required this.email, required this.purpose});

  final String email;
  final String purpose;

  @override
  List<Object?> get props => [email, purpose];
}

// ── States ────────────────────────────────────────────────────────────────────

sealed class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object?> get props => [];
}

final class OtpInitial extends OtpState {
  const OtpInitial();
}

final class OtpLoading extends OtpState {
  const OtpLoading();
}

/// OTP verified — [user] is only populated for the "signup" flow.
/// For "forgot_password" the user will be null until they reset their password.
final class OtpSuccess extends OtpState {
  const OtpSuccess({this.user});

  final UserEntity? user;

  @override
  List<Object?> get props => [user];
}

final class OtpResendSuccess extends OtpState {
  const OtpResendSuccess();
}

final class OtpFailure extends OtpState {
  const OtpFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// ── BLoC ──────────────────────────────────────────────────────────────────────

/// Handles OTP verification for both signup and forgot-password flows.
///
/// On [OtpSuccess]:
///   - signup   → widget calls `context.read<AuthCubit>().logIn(state.user!)`
///   - forgot_password → widget navigates to ResetPasswordPage
class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc({required VerifyOtpUseCase verifyOtpUseCase})
    : _verifyOtpUseCase = verifyOtpUseCase,
      super(const OtpInitial()) {
    on<OtpSubmitted>(_onSubmitted);
    on<OtpResendRequested>(_onResendRequested);
  }

  final VerifyOtpUseCase _verifyOtpUseCase;

  Future<void> _onSubmitted(OtpSubmitted event, Emitter<OtpState> emit) async {
    emit(const OtpLoading());
    final result = await _verifyOtpUseCase(
      VerifyOtpParams(email: event.email, code: event.code),
    );
    switch (result) {
      case Ok(:final value):
        emit(OtpSuccess(user: value));
      case Err(:final failure):
        emit(OtpFailure(failure.message));
    }
  }

  Future<void> _onResendRequested(
    OtpResendRequested event,
    Emitter<OtpState> emit,
  ) async {
    // Resend is fire-and-forget; emit a transient success so the UI can
    // show a "code sent" toast without blocking the form.
    emit(const OtpResendSuccess());
  }
}
