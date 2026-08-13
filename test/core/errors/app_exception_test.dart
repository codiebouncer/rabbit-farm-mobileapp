import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabbit_farm_mobileapp/core/errors/app_exception.dart';

void main() {
  RequestOptions request() => RequestOptions(path: '/test');

  test('maps 401 to unauthorized', () {
    final failure = AppException.fromDio(
      DioException(
        requestOptions: request(),
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: request(),
          statusCode: 401,
          data: {'message': 'Expired'},
        ),
      ),
    );
    expect(failure.kind, AppFailureKind.unauthorized);
    expect(failure.message, 'Expired');
  });

  test('maps validation errors and fields', () {
    final failure = AppException.fromDio(
      DioException(
        requestOptions: request(),
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: request(),
          statusCode: 400,
          data: {
            'errors': {
              'Email': ['Email is required.'],
            },
          },
        ),
      ),
    );
    expect(failure.kind, AppFailureKind.validation);
    expect(failure.fieldErrors['email'], ['Email is required.']);
  });

  test('maps timeout, network, server, and parsing errors', () {
    expect(
      AppException.fromDio(
        DioException(
          requestOptions: request(),
          type: DioExceptionType.connectionTimeout,
        ),
      ).kind,
      AppFailureKind.timeout,
    );
    expect(
      AppException.fromDio(
        DioException(
          requestOptions: request(),
          type: DioExceptionType.connectionError,
        ),
      ).kind,
      AppFailureKind.offline,
    );
    expect(
      AppException.fromDio(
        DioException(
          requestOptions: request(),
          type: DioExceptionType.badResponse,
          response: Response<dynamic>(
            requestOptions: request(),
            statusCode: 503,
          ),
        ),
      ).kind,
      AppFailureKind.server,
    );
    expect(
      AppException.from(const FormatException()).kind,
      AppFailureKind.parsing,
    );
  });
}
