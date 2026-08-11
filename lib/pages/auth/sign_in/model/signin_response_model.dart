
import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/core/constants/model/error_model.dart';
import 'package:wallet/pages/auth/sign_in/model/signin_model.dart';

part 'signin_response_model.g.dart';

@JsonSerializable()
class SigninResponseModel {
  final bool? succeeded;
  final SigninModel? data;
  final ErrorModel? error;

  SigninResponseModel({this.succeeded, this.data, this.error});

  factory SigninResponseModel.fromJson(Map<String, dynamic> json) {
    return _$SigninResponseModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SigninResponseModelToJson(this);
  }
}
