import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_envelope_parser.dart';
import '../../../../core/security/token_storage.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_session.dart';
import '../models/auth_user.dart';
import '../services/auth_service.dart';

class ApiAuthRepository implements AuthRepository {
  final AuthService _service;
  final TokenStorage _storage;
  const ApiAuthRepository(this._service, this._storage);

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _service.login(email: email, password: password);
      final session = AuthSession.fromJson(
        ApiEnvelopeParser.dataMap(response.data),
      );
      await _storage.write(
        StoredAuthCredentials(
          accessToken: session.accessToken,
          expiresAt: session.expiresAt,
          user: session.user.toJson(),
        ),
      );
      return session.user;
    } catch (error) {
      throw AppException.from(error);
    }
  }

  @override
  Future<AuthUser?> restore() async {
    final stored = await _storage.read();
    if (stored == null) return null;
    if (!stored.expiresAt.isAfter(DateTime.now().toUtc())) {
      await _storage.clear();
      return null;
    }
    final cachedUser = AuthUser.fromJson(stored.user);
    try {
      final response = await _service.me();
      return AuthUser.fromJson(ApiEnvelopeParser.dataMap(response.data));
    } catch (error) {
      final failure = AppException.from(error);
      if (failure.isConnectivityFailure) return cachedUser;
      if (failure.kind == AppFailureKind.unauthorized) await _storage.clear();
      throw failure;
    }
  }

  @override
  Future<void> logout() => _storage.clear();
}
