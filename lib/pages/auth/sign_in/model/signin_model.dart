import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/pages/auth/sign_in/model/user_model.dart';

part 'signin_model.g.dart';

@JsonSerializable()
class SigninModel {
  final String? token;
  final UserModel? user;

  SigninModel({this.token, this.user});

  factory SigninModel.fromJson(Map<String, dynamic> json) {
    return _$SigninModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SigninModelToJson(this);
  }
}
