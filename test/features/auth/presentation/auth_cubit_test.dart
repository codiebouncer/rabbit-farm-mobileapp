import 'package:flutter_test/flutter_test.dart';
import 'package:rabbit_farm_mobileapp/core/errors/app_exception.dart';
import 'package:rabbit_farm_mobileapp/features/auth/data/models/auth_user.dart';
import 'package:rabbit_farm_mobileapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:rabbit_farm_mobileapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:rabbit_farm_mobileapp/features/auth/presentation/cubit/auth_state.dart';

const user = AuthUser(
  userId: 'user-1',
  email: 'owner@greenburrow.com',
  role: 'FarmManager',
  farmId: 7,
  farmName: 'GreenBurrow Rabbit Farm',
);

class FakeAuthRepository implements AuthRepository {
  AuthUser? restoredUser;
  Object? loginError;
  bool loggedOut = false;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    if (loginError case final Object error) throw error;
    return user;
  }

  @override
  Future<void> logout() async => loggedOut = true;

  @override
  Future<AuthUser?> restore() async => restoredUser;
}

void main() {
  test('restores a cached authenticated user', () async {
    final repository = FakeAuthRepository()..restoredUser = user;
    final cubit = AuthCubit(repository);
    await cubit.restoreAuthentication();
    expect(cubit.state.status, AuthStatus.authenticated);
    expect(cubit.state.user, user);
    await cubit.close();
  });

  test('surfaces login validation failures', () async {
    final repository = FakeAuthRepository()
      ..loginError = const AppException(
        kind: AppFailureKind.validation,
        message: 'Check the form.',
        fieldErrors: {
          'email': ['Unknown account.'],
        },
      );
    final cubit = AuthCubit(repository);
    await cubit.login(email: 'owner@example.com', password: 'wrong');
    expect(cubit.state.status, AuthStatus.unauthenticated);
    expect(cubit.state.fieldErrors['email'], ['Unknown account.']);
    await cubit.close();
  });

  test('logout clears repository session and authentication state', () async {
    final repository = FakeAuthRepository();
    final cubit = AuthCubit(repository);
    await cubit.login(email: user.email, password: 'password');
    await cubit.logout();
    expect(repository.loggedOut, isTrue);
    expect(cubit.state.status, AuthStatus.unauthenticated);
    await cubit.close();
  });
}
