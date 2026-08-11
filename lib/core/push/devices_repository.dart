import 'package:dio/dio.dart';

import 'package:wallet/core/constants/base_api.dart';
import 'package:wallet/core/networking/api_constans.dart';
import 'package:wallet/core/networking/api_result.dart';
import 'package:wallet/core/networking/dio_factory.dart';

/// Registers the device's FCM token with the backend so the user can receive
/// push notifications. Separate from authentication — this is FCM token
/// management, not a session/JWT token.
class DevicesRepository extends BaseApi {
  final Dio _dio = DioFactory.getDio();

  Future<ApiResult<bool>> registerDevice({
    required String token,
    required String platform,
  }) {
    return execute(request: () async {
      await _dio.post(ApiConstants.myDevices, data: {'token': token, 'platform': platform});
      return true;
    });
  }

  Future<ApiResult<bool>> unregisterDevice(String token) {
    return execute(request: () async {
      await _dio.delete('${ApiConstants.myDevices}/$token');
      return true;
    });
  }
}
