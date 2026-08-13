import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/repositories/api_auth_repository.dart';
import '../../features/auth/data/services/auth_service.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/breeding/data/repository/breeding_repository.dart';
import '../../features/breeding/data/services/breeding_service.dart';
import '../../features/breeding/presentation/bloc/breeding_bloc.dart';
import '../../features/dashboard/data/repositories/dashboard_repository.dart';
import '../../features/dashboard/data/services/dashboard_service.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/rabbits/data/repositories/rabbit_repository.dart';
import '../../features/rabbits/data/services/rabbit_service.dart';
import '../../features/rabbits/presentation/bloc/rabbit_bloc.dart';
import '../config/app_environment.dart';
import '../network/dio_client.dart';
import '../routes/navigation_cubit.dart';
import '../security/token_storage.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  final tokenStorage = SecureTokenStorage();
  late final AuthCubit authCubit;
  final dioClient = DioClient(
    baseUrl: AppEnvironment.apiBaseUrl,
    tokenStorage: tokenStorage,
    onUnauthorized: () => authCubit.handleUnauthorized(),
  );
  final authRepository = ApiAuthRepository(
    AuthService(dioClient.dio),
    tokenStorage,
  );
  authCubit = AuthCubit(authRepository);

  sl.registerSingleton<TokenStorage>(tokenStorage);
  sl.registerSingleton<Dio>(dioClient.dio);
  sl.registerSingleton<AuthRepository>(authRepository);
  sl.registerSingleton<AuthCubit>(authCubit);

  sl.registerLazySingleton(() => DashboardService(sl()));
  sl.registerLazySingleton(() => DashboardRepository(sl()));
  sl.registerFactory(() => DashboardBloc(sl()));

  sl.registerLazySingleton(() => RabbitService(sl()));
  sl.registerLazySingleton(() => RabbitRepository(sl()));
  sl.registerFactory(() => RabbitBloc(sl()));

  sl.registerLazySingleton(() => BreedingService(sl()));
  sl.registerLazySingleton(() => BreedingRepository(sl()));
  sl.registerFactory(() => BreedingBloc(sl()));

  sl.registerFactory(() => NavigationCubit());
}
