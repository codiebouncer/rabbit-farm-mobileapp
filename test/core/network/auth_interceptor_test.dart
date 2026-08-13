import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabbit_farm_mobileapp/core/network/api_constants.dart';
import 'package:rabbit_farm_mobileapp/core/network/auth_interceptor.dart';
import 'package:rabbit_farm_mobileapp/core/security/token_storage.dart';

class _MemoryTokenStorage implements TokenStorage {
  String? token = 'secure-token';

  @override
  Future<void> clear() async => token = null;

  @override
  Future<StoredAuthCredentials?> read() async => null;

  @override
  Future<String?> readAccessToken() async => token;

  @override
  Future<void> write(StoredAuthCredentials credentials) async {
    token = credentials.accessToken;
  }
}

class _RecordingAdapter implements HttpClientAdapter {
  final int statusCode;
  RequestOptions? lastRequest;

  _RecordingAdapter({this.statusCode = 200});

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString(
      '{"success":true,"data":{}}',
      statusCode,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('adds bearer token to protected requests but not login', () async {
    final storage = _MemoryTokenStorage();
    final adapter = _RecordingAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
      ..httpClientAdapter = adapter
      ..interceptors.add(
        AuthInterceptor(storage: storage, onUnauthorized: () {}),
      );

    await dio.get<dynamic>('/rabbits');
    expect(
      adapter.lastRequest?.headers['Authorization'],
      'Bearer secure-token',
    );

    await dio.post<dynamic>(ApiPaths.authLogin);
    expect(adapter.lastRequest?.headers['Authorization'], isNull);
  });

  test('notifies authentication owner after a protected 401', () async {
    var unauthorizedCalls = 0;
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
      ..httpClientAdapter = _RecordingAdapter(statusCode: 401)
      ..interceptors.add(
        AuthInterceptor(
          storage: _MemoryTokenStorage(),
          onUnauthorized: () => unauthorizedCalls++,
        ),
      );

    await expectLater(
      dio.get<dynamic>('/rabbits'),
      throwsA(isA<DioException>()),
    );
    expect(unauthorizedCalls, 1);
  });
}
