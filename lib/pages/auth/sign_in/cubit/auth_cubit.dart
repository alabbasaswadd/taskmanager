import 'package:bloc/bloc.dart';

import 'package:wallet/core/constants/functions.dart';
import 'package:wallet/core/networking/api_result.dart';
import 'package:wallet/core/networking/dio_factory.dart';
import 'package:wallet/pages/auth/sign_in/api/auth_repository.dart';
import 'package:wallet/pages/auth/sign_in/model/signin_model.dart';
import 'package:wallet/pages/auth/sign_in/model/signin_response_model.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? error;
  const AuthState({this.status = AuthStatus.initial, this.error});
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({AuthRepository? repository})
      : _repo = repository ?? AuthRepository(),
        super(const AuthState());

  final AuthRepository _repo;

  Future<void> login(String email, String password) async {
    emit(const AuthState(status: AuthStatus.loading));

    final result = await _repo.login(email.trim(), password);

    await result.when(
      success: (SigninModel model) async {
        // 1. Configure Dio with the Bearer token.
        DioFactory.setTokenIntoHeaderAfterLogin(model.token);
        // 2. Persist the session (token + user).
        await UserSession.updateSession(
          SigninResponseModel(succeeded: true, data: model),
        );
        // NOTE: device-token registration (FCM) is intentionally skipped this
        // phase — see CLAUDE.md → Notifications.
        emit(const AuthState(status: AuthStatus.success));
      },
      failure: (e) async =>
          emit(AuthState(status: AuthStatus.error, error: e.message)),
    );
  }

  Future<void> logout() async {
    await UserSession.clear();
    DioFactory.clearToken();
    emit(const AuthState());
  }
}
