import 'package:dio/dio.dart';

import '../networking/api_error_handler.dart';
import '../networking/api_result.dart';
import 'model/error_model.dart';

abstract class BaseApi {
  Future<ApiResult<T>> execute<T>({
    required Future<T> Function() request,
  }) async {
    try {
      final response = await request();
      return ApiResult.success(response);
    } on DioException catch (e) {
      String? serverMessage;
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        serverMessage = data['message'] as String? ?? data['Message'] as String?;
      } else if (data is String && data.isNotEmpty) {
        serverMessage = data;
      }
      return ApiResult.failure(
        ErrorModel(
          message: serverMessage ?? ErrorHandler.handle(e).errorModel.message,
          errors: {},
        ),
      );
    } catch (e) {
      return ApiResult.failure(ErrorModel(message: e.toString(), errors: {}));
    }
  }
}
