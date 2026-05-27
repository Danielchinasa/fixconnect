import 'package:fix_connect_mobile/core/constants/api_constants.dart';
import 'package:fix_connect_mobile/core/network/api_client.dart';
import 'package:fix_connect_mobile/core/network/token_storage.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/data/datasources/auth_remote_datasource.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/data/repositories/auth_repository_impl.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/repositories/auth_repository.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/usecases/login_usecase.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/usecases/reset_password_usecase.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/usecases/send_otp_usecase.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/usecases/signup_usecase.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/presentation/blocs/forgot_password_bloc.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/presentation/blocs/login_bloc.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/presentation/blocs/otp_bloc.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/presentation/blocs/reset_password_bloc.dart';
import 'package:fix_connect_mobile/features/onboarding/auth/presentation/blocs/signup_bloc.dart';
import 'package:fix_connect_mobile/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:fix_connect_mobile/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:fix_connect_mobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:fix_connect_mobile/features/profile/domain/usecases/get_me_usecase.dart';
import 'package:fix_connect_mobile/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:fix_connect_mobile/features/profile/data/datasources/address_remote_datasource.dart';
import 'package:fix_connect_mobile/features/profile/data/repositories/address_repository_impl.dart';
import 'package:fix_connect_mobile/features/profile/domain/repositories/address_repository.dart';
import 'package:fix_connect_mobile/features/profile/presentation/cubit/address_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:fix_connect_mobile/features/profile/presentation/cubit/stats_cubit.dart';

/// Global service locator instance.
/// Access registered objects via `sl<MyType>()`.
final sl = GetIt.instance;

/// Register all dependencies.
/// Call once in [main] before [runApp].
Future<void> initDependencies() async {
  // ── External ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );

  // ── Core ───────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<TokenStorage>(
    () => TokenStorage(sl<FlutterSecureStorage>()),
  );

  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      tokenStorage: sl<TokenStorage>(),
      baseUrl: ApiConstants.baseUrl,
    ),
  );

  // ── Auth: Data ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<ApiClient>(), sl<TokenStorage>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  // ── Auth: Use cases ────────────────────────────────────────────────────────
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignupUseCase>(
    () => SignupUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SendOtpUseCase>(
    () => SendOtpUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ForgotPasswordUseCase>(
    () => ForgotPasswordUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(sl<AuthRepository>()),
  );

  // ── Auth: BLoCs (factories — new instance per page) ────────────────────────
  sl.registerFactory<LoginBloc>(
    () => LoginBloc(loginUseCase: sl<LoginUseCase>()),
  );
  sl.registerFactory<SignupBloc>(
    () => SignupBloc(
      signupUseCase: sl<SignupUseCase>(),
      sendOtpUseCase: sl<SendOtpUseCase>(),
    ),
  );
  sl.registerFactory<OtpBloc>(
    () => OtpBloc(verifyOtpUseCase: sl<VerifyOtpUseCase>()),
  );
  sl.registerFactory<ForgotPasswordBloc>(
    () =>
        ForgotPasswordBloc(forgotPasswordUseCase: sl<ForgotPasswordUseCase>()),
  );
  sl.registerFactory<ResetPasswordBloc>(
    () => ResetPasswordBloc(resetPasswordUseCase: sl<ResetPasswordUseCase>()),
  );

  // ── Profile: Data ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl<ApiClient>()),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl<ProfileRemoteDataSource>()),
  );

  // ── Profile: Use cases ────────────────────────────────────────────────────
  sl.registerLazySingleton<GetMeUseCase>(
    () => GetMeUseCase(sl<ProfileRepository>()),
  );

  // ── Profile: BLoC ─────────────────────────────────────────────────────────
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl<GetMeUseCase>()));

  // ── Address: Data/BLoC ────────────────────────────────────────────────────
  sl.registerLazySingleton<AddressRemoteDataSource>(
    () => AddressRemoteDataSourceImpl(sl<ApiClient>()),
  );

  sl.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(sl<AddressRemoteDataSource>()),
  );

  sl.registerFactory<AddressCubit>(() => AddressCubit(sl<AddressRepository>()));
  // ── Stats: BLoC ────────────────────────────────────────────────────────────
  sl.registerFactory(() => StatsCubit(sl<ApiClient>().dio));
}
