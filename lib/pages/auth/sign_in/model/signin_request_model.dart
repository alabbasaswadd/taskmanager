/// Login payload for `POST /api/auth/login`.
///
/// NOTE: this endpoint does not yet exist on the backend (auth is pending —
/// see CLAUDE.md → Known Issues). Manual JSON (no build_runner).
class SigninRequestModel {
  final String email;
  final String password;

  SigninRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}
