import 'package:fix_connect_mobile/core/network/token_storage.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/data/dto/user_dto.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/entities/user_entity.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/repositories/auth_repository.dart';
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
  AuthCubit(this._tokenStorage, [this._authRepository])
    : super(const AuthInitial());

  final TokenStorage _tokenStorage;
  final AuthRepository? _authRepository;

  /// Called once on app start to restore an existing session.
  /// Emits [AuthAuthenticated] if a stored token is found, otherwise [AuthUnauthenticated].
  Future<void> init() async {
    final hasToken = await _tokenStorage.hasToken();
    if (!hasToken) {
      emit(const AuthUnauthenticated());
      return;
    }
    final userJson = await _tokenStorage.getUser();
    final user = userJson != null ? UserDto.fromJson(userJson) : null;
    emit(AuthAuthenticated(user));
  }

  /// Call when login or OTP verification succeeds.
  void logIn([UserEntity? user]) {
    emit(AuthAuthenticated(user));
    // Persist user data in the background for session restoration.
    if (user is UserDto) {
      _tokenStorage.saveUser(user.toJson());
    }
  }

  /// Call when the user logs out.
  void logOut() {
    emit(const AuthUnauthenticated());
    _tokenStorage.clear();
  }

  /// Calls backend logout first, then always clears local session.
  Future<void> logoutRequested() async {
    try {
      await _authRepository?.logout();
    } catch (_) {
      // Ignore remote errors and force local logout to unblock the user.
    }
    logOut();
  }
}
