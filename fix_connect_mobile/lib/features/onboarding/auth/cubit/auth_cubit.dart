import 'package:fix_connect_mobile/features/onboarding/auth/domain/entities/user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── States ────────────────────────────────────────────────────────────────────

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated([this.user]);

  /// Null during mock/stub flows; populated once the real API is integrated.
  final UserEntity? user;
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

/// Holds the global session state.
///
/// The root [BlocListener] in [MyApp] reacts to state changes and navigates
/// to the appropriate screen automatically.
///
/// Feature BLoCs (LoginBloc, OtpBloc …) emit their own success states.
/// When a page receives a success, it calls [logIn] here to set the session.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  /// Call when login or OTP verification succeeds.
  /// Pass [user] once real API integration is wired up.
  void logIn([UserEntity? user]) => emit(AuthAuthenticated(user));

  /// Call when the user logs out.
  void logOut() => emit(const AuthUnauthenticated());
}
