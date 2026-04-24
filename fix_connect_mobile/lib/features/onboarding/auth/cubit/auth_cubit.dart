import 'package:flutter_bloc/flutter_bloc.dart';

/// Represents the authentication status of the user.
abstract class AuthState {}

/// Initial state before any auth action has occurred.
class AuthInitial extends AuthState {}

/// User has successfully authenticated.
class AuthAuthenticated extends AuthState {}

/// User has logged out or session has expired.
class AuthUnauthenticated extends AuthState {}

/// Manages authentication state for the app.
/// The root [BlocListener] in [MyApp] reacts to state changes
/// and navigates to the appropriate screen automatically.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  /// Call when login / OTP verification succeeds.
  void logIn() => emit(AuthAuthenticated());

  /// Call when the user logs out.
  void logOut() => emit(AuthUnauthenticated());
}
