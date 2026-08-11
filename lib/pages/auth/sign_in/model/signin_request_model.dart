import 'package:json_annotation/json_annotation.dart';

part 'signin_request_model.g.dart';

@JsonSerializable()
class SigninRequestModel {
  final String email;
  final String password;
  final String? tokenFcm;

  SigninRequestModel({
    required this.email,
    required this.password,
    this.tokenFcm,
  });

  factory SigninRequestModel.fromJson(Map<String, dynamic> json) {
    return _$SigninRequestModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SigninRequestModelToJson(this);
  }
}
