import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';

class AuthService {
  final Dio _dio;
  const AuthService(this._dio);

  Future<Response<dynamic>> login({
    required String email,
    required String password,
  }) => _dio.post<dynamic>(
    ApiPaths.authLogin,
    data: {'email': email, 'password': password},
  );
  Future<Response<dynamic>> me() => _dio.get<dynamic>(ApiPaths.authMe);
}
