import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StoredAuthCredentials {
  final String accessToken;
  final DateTime expiresAt;
  final Map<String, dynamic> user;

  const StoredAuthCredentials({
    required this.accessToken,
    required this.expiresAt,
    required this.user,
  });
}

abstract interface class TokenStorage {
  Future<StoredAuthCredentials?> read();

  Future<String?> readAccessToken();

  Future<void> write(StoredAuthCredentials credentials);

  Future<void> clear();
}

class SecureTokenStorage implements TokenStorage {
  static const _sessionKey = 'rabbit_farm.auth.session';
  final FlutterSecureStorage _storage;

  const SecureTokenStorage({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) : _storage = storage;

  @override
  Future<StoredAuthCredentials?> read() async {
    final encoded = await _storage.read(key: _sessionKey);
    if (encoded == null || encoded.isEmpty) {
      return null;
    }

    try {
      final json = jsonDecode(encoded);
      if (json is! Map<String, dynamic>) {
        await clear();
        return null;
      }
      final token = json['accessToken'];
      final expiry = DateTime.tryParse(json['expiresAt']?.toString() ?? '');
      final user = json['user'];
      if (token is! String || token.isEmpty || expiry == null || user is! Map) {
        await clear();
        return null;
      }

      return StoredAuthCredentials(
        accessToken: token,
        expiresAt: expiry.toUtc(),
        user: Map<String, dynamic>.from(user),
      );
    } on FormatException {
      await clear();
      return null;
    }
  }

  @override
  Future<String?> readAccessToken() async => (await read())?.accessToken;

  @override
  Future<void> write(StoredAuthCredentials credentials) {
    return _storage.write(
      key: _sessionKey,
      value: jsonEncode({
        'accessToken': credentials.accessToken,
        'expiresAt': credentials.expiresAt.toUtc().toIso8601String(),
        'user': credentials.user,
      }),
    );
  }

  @override
  Future<void> clear() => _storage.delete(key: _sessionKey);
}
