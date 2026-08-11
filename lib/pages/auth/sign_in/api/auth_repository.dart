import 'package:dio/dio.dart';

import 'package:wallet/core/constants/base_api.dart';
import 'package:wallet/core/networking/api_constans.dart';
import 'package:wallet/core/networking/api_result.dart';
import 'package:wallet/core/networking/dio_factory.dart';
import 'package:wallet/pages/auth/sign_in/model/signin_model.dart';
import 'package:wallet/pages/auth/sign_in/model/signin_request_model.dart';
import 'package:wallet/pages/auth/sign_in/model/user_model.dart';

/// Authentication + current-user data source.
///
/// Login response is parsed defensively: accepts either a bare `{ token, user }`
/// or an envelope `{ data: { token, user } }`.
class AuthRepository extends BaseApi {
  final Dio _dio = DioFactory.getDio();

  Future<ApiResult<SigninModel>> login(String email, String password) {
    return execute(request: () async {
      final res = await _dio.post(
        ApiConstants.login,
        data: SigninRequestModel(email: email, password: password).toJson(),
      );
      final data = res.data;
      final payload = (data is Map && data['data'] is Map)
          ? data['data'] as Map
          : data as Map;
      return SigninModel.fromJson(Map<String, dynamic>.from(payload));
    });
  }

  Future<ApiResult<UserModel>> getMe() {
    return execute(request: () async {
      final res = await _dio.get(ApiConstants.me);
      return UserModel.fromJson(res.data as Map<String, dynamic>);
    });
  }

  Future<ApiResult<UserModel>> updateMe(UpdateUserRequest body) {
    return execute(request: () async {
      final res = await _dio.put(ApiConstants.me, data: body.toJson());
      return UserModel.fromJson(res.data as Map<String, dynamic>);
    });
  }
}
