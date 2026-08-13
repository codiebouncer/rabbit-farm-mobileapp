import '../../data/models/auth_user.dart';

abstract interface class AuthRepository {
  Future<AuthUser?> restore();
  Future<AuthUser> login({required String email, required String password});
  Future<void> logout();
}
