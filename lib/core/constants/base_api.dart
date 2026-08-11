import '../networking/api_error_handler.dart';
import '../networking/api_result.dart';

/// Base class for all feature API classes. Wraps a request in try/catch and
/// funnels every error through [ErrorHandler] so callers always receive a
/// uniform `ApiResult<T>` (`success` or `failure(ErrorModel)`).
///
/// Feature APIs use `DioFactory.getDio()` — they must NOT create their own Dio.
abstract class BaseApi {
  Future<ApiResult<T>> execute<T>({
    required Future<T> Function() request,
  }) async {
    try {
      final response = await request();
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
