import 'dart:async';
import 'package:dio/dio.dart';
import '../errors/app_exception.dart';
import '../security/token_storage.dart';
import 'auth_interceptor.dart';

class DioClient {
  final Dio dio;
  DioClient({
    required String baseUrl,
    required TokenStorage tokenStorage,
    required FutureOr<void> Function() onUnauthorized,
  }) : dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: const Duration(seconds: 15),
           receiveTimeout: const Duration(seconds: 20),
           sendTimeout: const Duration(seconds: 20),
           headers: const {'Content-Type': 'application/json'},
         ),
       ) {
    dio.interceptors.addAll([
      AuthInterceptor(storage: tokenStorage, onUnauthorized: onUnauthorized),
      InterceptorsWrapper(
        onError: (error, handler) =>
            handler.next(error.copyWith(error: AppException.fromDio(error))),
      ),
    ]);
  }
}
