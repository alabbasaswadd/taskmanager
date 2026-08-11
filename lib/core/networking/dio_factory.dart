import 'package:dio/dio.dart';
import 'package:wallet/core/networking/api_constans.dart';

/// Owns the single shared [Dio] instance and the Bearer token.
///
/// Token is attached automatically to every request. A centralized error
/// interceptor invokes [onUnauthorized] once when the server returns 401 so
/// session-expiry handling lives in exactly one place (not in each API class).
class DioFactory {
  DioFactory._();

  static Dio? _dio;
  static String _token = '';

  /// Registered by the app at startup: clear session + navigate to login.
  static void Function()? onUnauthorized;

  static Dio getDio() {
    if (_dio == null) {
      const timeOut = Duration(seconds: 30);
      _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.apiBaseUrl,
          connectTimeout: timeOut,
          receiveTimeout: timeOut,
          sendTimeout: timeOut,
          headers: {
            if (_token.isNotEmpty) 'Authorization': 'Bearer $_token',
          },
        ),
      );
      _addInterceptors();
    }
    return _dio!;
  }

  /// Attach/remove the Bearer token. Called after login and on logout.
  static void setTokenIntoHeaderAfterLogin(String? token) {
    _token = token ?? '';
    if (_token.isEmpty) {
      _dio?.options.headers.remove('Authorization');
    } else {
      _dio?.options.headers['Authorization'] = 'Bearer $_token';
    }
  }

  static void clearToken() => setTokenIntoHeaderAfterLogin(null);

  static void _addInterceptors() {
    _dio?.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.data != null && options.contentType == null) {
            options.contentType = Headers.jsonContentType;
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Central session-expiry hook — runs once, regardless of caller.
            onUnauthorized?.call();
          }
          handler.next(error);
        },
      ),
    );
  }
}
