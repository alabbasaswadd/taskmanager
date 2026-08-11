/// Login payload for `POST /api/auth/login`.
class SigninRequestModel {
  final String email;
  final String password;

  SigninRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}
