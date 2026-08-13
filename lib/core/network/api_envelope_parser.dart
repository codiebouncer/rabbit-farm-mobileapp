import '../errors/app_exception.dart';

abstract final class ApiEnvelopeParser {
  static Map<String, dynamic> dataMap(dynamic body) {
    final value = data(body);
    if (value is! Map<String, dynamic>) {
      throw const AppException(
        kind: AppFailureKind.parsing,
        message: 'The server returned an invalid record.',
      );
    }
    return value;
  }

  static List<dynamic> dataList(dynamic body) {
    final value = data(body);
    if (value is! List) {
      throw const AppException(
        kind: AppFailureKind.parsing,
        message: 'The server returned an invalid list.',
      );
    }
    return value;
  }

  static dynamic data(dynamic body) {
    if (body is! Map<String, dynamic>) {
      throw const AppException(
        kind: AppFailureKind.parsing,
        message: 'The server response was not valid JSON.',
      );
    }
    if (body['success'] != true) {
      throw AppException(
        kind: AppFailureKind.validation,
        message: body['message'] is String
            ? body['message'] as String
            : 'The operation could not be completed.',
      );
    }
    if (!body.containsKey('data') || body['data'] == null) {
      throw const AppException(
        kind: AppFailureKind.parsing,
        message: 'The server response did not contain the expected data.',
      );
    }
    return body['data'];
  }
}
