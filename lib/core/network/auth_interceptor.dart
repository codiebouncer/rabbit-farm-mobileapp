import 'dart:async';
import 'package:dio/dio.dart';
import '../security/token_storage.dart';
import 'api_constants.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _storage;
  final FutureOr<void> Function() _onUnauthorized;
  bool _handlingUnauthorized = false;
  AuthInterceptor({
    required TokenStorage storage,
    required FutureOr<void> Function() onUnauthorized,
  }) : _storage = storage,
       _onUnauthorized = onUnauthorized;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path != ApiPaths.authLogin) {
      final token = await _storage.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        err.requestOptions.path != ApiPaths.authLogin &&
        !_handlingUnauthorized) {
      _handlingUnauthorized = true;
      try {
        await _onUnauthorized();
      } finally {
        _handlingUnauthorized = false;
      }
    }
    handler.next(err);
  }
}
