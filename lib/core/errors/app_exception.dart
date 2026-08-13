import 'dart:io';

import 'package:dio/dio.dart';

enum AppFailureKind {
  unauthorized,
  validation,
  offline,
  network,
  timeout,
  cancelled,
  notFound,
  server,
  parsing,
  unknown,
}

class AppException implements Exception {
  final AppFailureKind kind;
  final String message;
  final int? statusCode;
  final Map<String, List<String>> fieldErrors;

  const AppException({
    required this.kind,
    required this.message,
    this.statusCode,
    this.fieldErrors = const {},
  });

  factory AppException.from(Object error) {
    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      if (error.error is AppException) {
        return error.error as AppException;
      }
      return AppException.fromDio(error);
    }

    if (error is FormatException || error is TypeError) {
      return const AppException(
        kind: AppFailureKind.parsing,
        message: 'The server returned data the app could not read.',
      );
    }

    return const AppException(
      kind: AppFailureKind.unknown,
      message: 'Something unexpected happened. Please try again.',
    );
  }

  factory AppException.fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppException(
          kind: AppFailureKind.timeout,
          message: 'The request took too long. Please try again.',
        );
      case DioExceptionType.connectionError:
        return const AppException(
          kind: AppFailureKind.offline,
          message: 'You appear to be offline. Check your connection and retry.',
        );
      case DioExceptionType.cancel:
        return const AppException(
          kind: AppFailureKind.cancelled,
          message: 'The request was cancelled.',
        );
      case DioExceptionType.badResponse:
        return _fromResponse(error.response);
      case DioExceptionType.badCertificate:
        return const AppException(
          kind: AppFailureKind.network,
          message:
              'A secure connection to the server could not be established.',
        );
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return const AppException(
            kind: AppFailureKind.offline,
            message:
                'You appear to be offline. Check your connection and retry.',
          );
        }
        return const AppException(
          kind: AppFailureKind.unknown,
          message: 'Unable to complete the request. Please try again.',
        );
    }
  }

  static AppException _fromResponse(Response<dynamic>? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;
    final fieldErrors = _readFieldErrors(data);
    final serverMessage = _readMessage(data);

    if (statusCode == 401) {
      return AppException(
        kind: AppFailureKind.unauthorized,
        message:
            serverMessage ?? 'Your session has expired. Please sign in again.',
        statusCode: statusCode,
      );
    }
    if (statusCode == 400 || statusCode == 409 || statusCode == 422) {
      return AppException(
        kind: AppFailureKind.validation,
        message:
            serverMessage ??
            fieldErrors.values.expand((messages) => messages).firstOrNull ??
            'Check the information and try again.',
        statusCode: statusCode,
        fieldErrors: fieldErrors,
      );
    }
    if (statusCode == 404) {
      return AppException(
        kind: AppFailureKind.notFound,
        message: serverMessage ?? 'The requested record was not found.',
        statusCode: statusCode,
      );
    }
    if (statusCode != null && statusCode >= 500) {
      return AppException(
        kind: AppFailureKind.server,
        message: 'The server could not complete the request. Please try again.',
        statusCode: statusCode,
      );
    }

    return AppException(
      kind: AppFailureKind.unknown,
      message:
          serverMessage ?? 'Unable to complete the request. Please try again.',
      statusCode: statusCode,
    );
  }

  static String? _readMessage(dynamic data) {
    if (data is! Map) {
      return null;
    }
    final message = data['message'] ?? data['detail'] ?? data['title'];
    return message is String && message.trim().isNotEmpty
        ? message.trim()
        : null;
  }

  static Map<String, List<String>> _readFieldErrors(dynamic data) {
    if (data is! Map || data['errors'] is! Map) {
      return const {};
    }

    final result = <String, List<String>>{};
    (data['errors'] as Map).forEach((key, value) {
      if (key is! String) {
        return;
      }
      if (value is List) {
        result[key.toLowerCase()] = value.whereType<String>().toList();
      } else if (value is String) {
        result[key.toLowerCase()] = [value];
      }
    });
    return result;
  }

  bool get isConnectivityFailure =>
      kind == AppFailureKind.offline || kind == AppFailureKind.timeout;

  @override
  String toString() => message;
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
