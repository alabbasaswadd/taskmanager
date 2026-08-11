import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiError {
  static String fromException(dynamic e) {
    if (e is DioException) {
      return e.response?.data.toString() ?? "Server Error";
    }
    debugPrint('ApiError [${e.runtimeType}]: $e');
    return "Error: ${e.runtimeType} → $e";
  }
}
