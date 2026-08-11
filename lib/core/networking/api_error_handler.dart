import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../constants/model/error_model.dart';
import 'api_constans.dart';

/// Single place that converts any thrown error (Dio transport errors, HTTP
/// status codes, RFC 7807 ProblemDetails bodies) into a uniform, localized
/// [ErrorModel]. Screens must never inspect [DioException], [SocketException],
/// [FormatException] or raw status codes — they only ever see an [ErrorModel].
class ErrorHandler {
  ErrorHandler._();

  static ErrorModel handle(dynamic error) {
    if (error is DioException) return _fromDio(error);
    if (error is SocketException) {
      return _make(ApiErrorType.noInternet, ApiErrors.noInternetError);
    }
    return _make(ApiErrorType.unknown, ApiErrors.unknownError);
  }

  static ErrorModel _fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return _make(ApiErrorType.timeout, ApiErrors.timeoutError);
      case DioExceptionType.connectionError:
        return _make(ApiErrorType.noInternet, ApiErrors.noInternetError);
      case DioExceptionType.cancel:
        return _make(ApiErrorType.cancelled, ApiErrors.unknownError);
      case DioExceptionType.badCertificate:
        return _make(ApiErrorType.server, ApiErrors.serviceUnavailable);
      case DioExceptionType.badResponse:
        return _fromStatus(e.response?.statusCode, e.response?.data);
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return _make(ApiErrorType.noInternet, ApiErrors.noInternetError);
        }
        if (e.response != null) {
          return _fromStatus(e.response?.statusCode, e.response?.data);
        }
        return _make(ApiErrorType.unknown, ApiErrors.unknownError);
      default:
        // Covers any future DioExceptionType additions (e.g. transformTimeout).
        return _make(ApiErrorType.unknown, ApiErrors.unknownError);
    }
  }

  static ErrorModel _fromStatus(int? status, dynamic body) {
    final parsed = _parseProblemDetails(body);
    final type = _typeForStatus(status);
    final fallbackKey = _fallbackKeyFor(type);

    return ErrorModel(
      message: parsed.message ?? fallbackKey.tr,
      errors: parsed.errors,
      statusCode: status,
      type: type,
    );
  }

  static ApiErrorType _typeForStatus(int? status) {
    switch (status) {
      case 400:
        return ApiErrorType.badRequest;
      case 401:
        return ApiErrorType.unauthorized;
      case 403:
        return ApiErrorType.forbidden;
      case 404:
        return ApiErrorType.notFound;
      case 409:
        return ApiErrorType.conflict;
      case 422:
        return ApiErrorType.validation;
      case 429:
        return ApiErrorType.tooManyRequests;
      case 500:
        return ApiErrorType.server;
      case 502:
      case 503:
      case 504:
        return ApiErrorType.serviceUnavailable;
      default:
        return ApiErrorType.unknown;
    }
  }

  static String _fallbackKeyFor(ApiErrorType type) {
    switch (type) {
      case ApiErrorType.badRequest:
        return ApiErrors.badRequestError;
      case ApiErrorType.unauthorized:
        return ApiErrors.unauthorizedError;
      case ApiErrorType.forbidden:
        return ApiErrors.forbiddenError;
      case ApiErrorType.notFound:
        return ApiErrors.notFoundError;
      case ApiErrorType.conflict:
        return ApiErrors.conflictError;
      case ApiErrorType.validation:
        return ApiErrors.validationError;
      case ApiErrorType.tooManyRequests:
        return ApiErrors.tooManyRequests;
      case ApiErrorType.server:
        return ApiErrors.internalServerError;
      case ApiErrorType.serviceUnavailable:
        return ApiErrors.serviceUnavailable;
      case ApiErrorType.timeout:
        return ApiErrors.timeoutError;
      case ApiErrorType.noInternet:
        return ApiErrors.noInternetError;
      case ApiErrorType.cancelled:
      case ApiErrorType.unknown:
        return ApiErrors.unknownError;
    }
  }

  static ErrorModel _make(ApiErrorType type, String messageKey) =>
      ErrorModel(message: messageKey.tr, type: type);

  /// Parses an RFC 7807 ProblemDetails / ValidationProblemDetails body.
  static _ParsedBody _parseProblemDetails(dynamic body) {
    if (body is Map) {
      final map = body.map((k, v) => MapEntry(k.toString(), v));

      final message = (map['detail'] ?? map['title'] ?? map['message'])
          ?.toString();

      Map<String, List<String>>? errors;
      final rawErrors = map['errors'];
      if (rawErrors is Map) {
        errors = {};
        rawErrors.forEach((key, value) {
          final list = value is List
              ? value.map((e) => e.toString()).toList()
              : <String>[value.toString()];
          errors![key.toString()] = list;
        });
        if (errors.isEmpty) errors = null;
      }
      return _ParsedBody(message: message, errors: errors);
    }

    if (body is String && body.trim().isNotEmpty && body.length < 300) {
      return _ParsedBody(message: body);
    }
    return const _ParsedBody();
  }
}

class _ParsedBody {
  final String? message;
  final Map<String, List<String>>? errors;
  const _ParsedBody({this.message, this.errors});
}
