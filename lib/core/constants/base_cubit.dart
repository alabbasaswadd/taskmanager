// =======================================================
// base_cubit.dart
// =======================================================
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../networking/api_result.dart';

abstract class BaseCubit<TState> extends Cubit<TState> {
  BaseCubit(super.initialState);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool validateForm() {
    final form = formKey.currentState;
    if (form == null) return false;
    return form.validate();
  }

  Future<void> executeApi<T>({
    required Future<ApiResult<T>> Function() request,
    required void Function() onLoading,
    required Future<void> Function(T data) onSuccess,
    required void Function(String message) onError,
    String defaultErrorMessage = "حدث خطأ، حاول مرة أخرى",
  }) async {
    onLoading();

    final response = await request();

    response.when(
      success: (data) async {
        await onSuccess(data);
      },
      failure: (error) {
        onError(error.message ?? defaultErrorMessage);
      },
    );
  }

  void disposeControllers(List<TextEditingController> controllers) {
    for (final controller in controllers) {
      controller.dispose();
    }
  }
}
