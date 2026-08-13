import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/service_locator.dart';
import 'core/routes/app_router.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  final authCubit = sl<AuthCubit>();
  final router = createAppRouter(authCubit);
  authCubit.restoreAuthentication();

  runApp(RabbitFarmApp(authCubit: authCubit, router: router));
}
