import 'package:dio/dio.dart';
import 'package:wallet/core/networking/api_constans.dart';

class DioFactory {
  DioFactory._();

  static Dio? _dio;
  static String _token = '';

  static Dio getDio() {
    if (_dio == null) {
      const timeOut = Duration(seconds: 30);
      _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.apiBaseUrl,
          connectTimeout: timeOut,
          receiveTimeout: timeOut,
          headers: {
            if (_token.isNotEmpty) 'Authorization': 'Bearer $_token',
          },
        ),
      );
      _addInterceptor();
    }
    return _dio!;
  }

  static void setTokenIntoHeaderAfterLogin(String token) {
    _token = token;
    if (token.isEmpty) {
      _dio?.options.headers.remove('Authorization');
    } else {
      _dio?.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  static void _addInterceptor() {
    _dio?.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.data != null && options.contentType == null) {
            options.contentType = Headers.jsonContentType;
          }
          handler.next(options);
        },
      ),
    );
  }
}
