import 'auth_user.dart';

class AuthSession {
  final String accessToken;
  final DateTime expiresAt;
  final AuthUser user;

  const AuthSession({
    required this.accessToken,
    required this.expiresAt,
    required this.user,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final token = json['accessToken'];
    final expiresAt = DateTime.tryParse(json['expiresAt']?.toString() ?? '');
    final user = json['user'];
    if (token is! String ||
        token.isEmpty ||
        expiresAt == null ||
        user is! Map) {
      throw const FormatException('Invalid authentication session');
    }
    return AuthSession(
      accessToken: token,
      expiresAt: expiresAt.toUtc(),
      user: AuthUser.fromJson(Map<String, dynamic>.from(user)),
    );
  }
}
