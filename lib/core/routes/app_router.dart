import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/pages/auth_loading_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/breeding/presentation/bloc/breeding_bloc.dart';
import '../../features/breeding/presentation/pages/add_breeding_page.dart';
import '../../features/breeding/presentation/pages/breeding_details_page.dart';
import '../../features/rabbits/presentation/bloc/rabbit_bloc.dart';
import '../../features/rabbits/presentation/pages/add_rabbit_page.dart';
import '../../features/rabbits/presentation/pages/rabbit_details_page.dart';
import '../../features/rabbits/presentation/pages/edit_rabbit_page.dart';
import '../../features/rabbits/presentation/pages/move_rabbit_page.dart';
import '../../shared/navigation/main_navigation_page.dart';
import '../di/service_locator.dart';
import 'route_names.dart';

GoRouter createAppRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: RouteNames.authLoading,
    refreshListenable: _RouterRefresh(authCubit.stream),
    redirect: (context, state) {
      final status = authCubit.state.status;
      final atAuthRoute =
          state.matchedLocation == RouteNames.login ||
          state.matchedLocation == RouteNames.authLoading;
      if (status == AuthStatus.initial || status == AuthStatus.restoring) {
        return state.matchedLocation == RouteNames.authLoading
            ? null
            : RouteNames.authLoading;
      }
      if (status != AuthStatus.authenticated) {
        return state.matchedLocation == RouteNames.login
            ? null
            : RouteNames.login;
      }
      return atAuthRoute ? RouteNames.home : null;
    },
    routes: [
      GoRoute(
        path: RouteNames.authLoading,
        builder: (context, state) => const AuthLoadingPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const MainNavigationPage(),
      ),
      GoRoute(
        path: RouteNames.addRabbit,
        builder: (_, _) => BlocProvider(
          create: (_) => sl<RabbitBloc>(),
          child: const AddRabbitPage(),
        ),
      ),
      GoRoute(
        path: '${RouteNames.rabbits}/:rabbitId/edit',
        builder: (_, state) => BlocProvider(
          create: (_) => sl<RabbitBloc>(),
          child: EditRabbitPage(
            rabbitId: state.pathParameters['rabbitId'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: '${RouteNames.rabbits}/:rabbitId/move-cage',
        builder: (_, state) => BlocProvider(
          create: (_) => sl<RabbitBloc>(),
          child: MoveRabbitPage(
            rabbitId: state.pathParameters['rabbitId'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: '${RouteNames.rabbits}/:rabbitId',
        builder: (_, state) => BlocProvider(
          create: (_) => sl<RabbitBloc>(),
          child: RabbitDetailsPage(
            rabbitId: state.pathParameters['rabbitId'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: RouteNames.addBreeding,
        builder: (_, _) => BlocProvider(
          create: (_) => sl<BreedingBloc>(),
          child: const AddBreedingPage(),
        ),
      ),
      GoRoute(
        path: '${RouteNames.breedings}/:breedingId',
        builder: (_, state) => BlocProvider(
          create: (_) => sl<BreedingBloc>(),
          child: BreedingDetailsPage(
            breedingId: state.pathParameters['breedingId'] ?? '',
          ),
        ),
      ),
    ],
  );
}

class _RouterRefresh extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;
  _RouterRefresh(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
