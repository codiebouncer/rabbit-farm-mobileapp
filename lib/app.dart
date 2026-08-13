import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

class RabbitFarmApp extends StatelessWidget {
  final AuthCubit authCubit;
  final GoRouter router;

  const RabbitFarmApp({
    required this.authCubit,
    required this.router,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: authCubit,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'GreenBurrow Rabbit Farm',
        theme: AppTheme.light,
        routerConfig: router,
      ),
    );
  }
}
