import 'package:wallet/pages/auth/sign_in/model/user_model.dart';

/// Session payload `{ token, user }`. Manual JSON (no build_runner).
class SigninModel {
  final String? token;
  final UserModel? user;

  SigninModel({this.token, this.user});

  factory SigninModel.fromJson(Map<String, dynamic> json) => SigninModel(
        token: json['token'] as String?,
        user: json['user'] == null
            ? null
            : UserModel.fromJson(Map<String, dynamic>.from(json['user'] as Map)),
      );

  Map<String, dynamic> toJson() => {
        'token': token,
        'user': user?.toJson(),
      };
}
