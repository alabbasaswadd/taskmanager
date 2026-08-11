import 'package:wallet/core/constants/model/error_model.dart';
import 'package:wallet/pages/auth/sign_in/model/signin_model.dart';

/// Login response envelope. Manual JSON (no build_runner).
class SigninResponseModel {
  final bool? succeeded;
  final SigninModel? data;
  final ErrorModel? error;

  SigninResponseModel({this.succeeded, this.data, this.error});

  factory SigninResponseModel.fromJson(Map<String, dynamic> json) =>
      SigninResponseModel(
        succeeded: json['succeeded'] as bool?,
        data: json['data'] == null
            ? null
            : SigninModel.fromJson(Map<String, dynamic>.from(json['data'] as Map)),
        error: json['error'] == null
            ? null
            : ErrorModel.fromJson(Map<String, dynamic>.from(json['error'] as Map)),
      );

  Map<String, dynamic> toJson() => {
        'succeeded': succeeded,
        'data': data?.toJson(),
        'error': error?.toJson(),
      };
}
