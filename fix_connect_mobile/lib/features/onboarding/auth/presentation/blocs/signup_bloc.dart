import 'package:equatable/equatable.dart';
import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/usecases/signup_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── Events ────────────────────────────────────────────────────────────────────

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

final class SignupSubmitted extends SignupEvent {
  const SignupSubmitted({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  final String name;
  final String email;
  final String phone;
  final String password;

  @override
  List<Object?> get props => [name, email, phone];
}

// ── States ────────────────────────────────────────────────────────────────────

sealed class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object?> get props => [];
}

final class SignupInitial extends SignupState {
  const SignupInitial();
}

final class SignupLoading extends SignupState {
  const SignupLoading();
}

/// Signup API call succeeded — the OTP has been sent to [email].
final class SignupSuccess extends SignupState {
  const SignupSuccess(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

final class SignupFailure extends SignupState {
  const SignupFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// ── BLoC ──────────────────────────────────────────────────────────────────────

/// Handles the create-account form submission.
///
/// On [SignupSuccess] the widget should navigate to the OTP page,
/// passing `OtpArgs(email: state.email, source: OtpSource.signup)`.
class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({required SignupUseCase signupUseCase})
    : _signupUseCase = signupUseCase,
      super(const SignupInitial()) {
    on<SignupSubmitted>(_onSubmitted);
  }

  final SignupUseCase _signupUseCase;

  Future<void> _onSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    emit(const SignupLoading());
    final result = await _signupUseCase(
      SignupParams(
        name: event.name,
        email: event.email,
        phone: event.phone,
        password: event.password,
      ),
    );
    switch (result) {
      case Ok():
        emit(SignupSuccess(event.email));
      case Err(:final failure):
        emit(SignupFailure(failure.message));
    }
  }
}
