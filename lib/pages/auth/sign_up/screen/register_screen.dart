import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:wallet/core/components/app_button.dart';
import 'package:wallet/core/components/app_snackbar.dart';
import 'package:wallet/core/components/app_text.dart';
import 'package:wallet/core/components/app_text_form_field.dart';
import 'package:wallet/core/constants/colors.dart';
import 'package:wallet/pages/auth/sign_in/cubit/auth_cubit.dart';
import 'package:wallet/pages/main/main_shell.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  static const String id = "/register";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();
  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(
            firstName: _firstName.text,
            lastName: _lastName.text,
            email: _email.text,
            password: _password.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('create_account'.tr)),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.success) {
              Get.offAllNamed(MainShell.id);
            } else if (state.status == AuthStatus.error) {
              AppSnackbar.showError(context, state.error ?? 'error_unknown'.tr);
            }
          },
          builder: (context, state) {
            final loading = state.status == AuthStatus.loading;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppText('register_subtitle'.tr,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.kGreyColor,
                        maxLines: 2),
                    SizedBox(height: 20.h),
                    AppTextFormField(
                      label: 'first_name'.tr,
                      controller: _firstName,
                      icon: Icons.person_outline,
                      textInputAction: TextInputAction.next,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'validation_required'.tr : null,
                    ),
                    AppTextFormField(
                      label: 'last_name'.tr,
                      controller: _lastName,
                      icon: Icons.person_outline,
                      textInputAction: TextInputAction.next,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'validation_required'.tr : null,
                    ),
                    AppTextFormField(
                      label: 'email'.tr,
                      controller: _email,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (v) =>
                          (v == null || !v.contains('@')) ? 'validation_email'.tr : null,
                    ),
                    AppTextFormField(
                      label: 'password'.tr,
                      controller: _password,
                      icon: Icons.lock_outline_rounded,
                      obscureText: _obscure,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(context),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      validator: (v) =>
                          (v == null || v.length < 6) ? 'validation_password_6'.tr : null,
                    ),
                    SizedBox(height: 24.h),
                    AppButton(
                      text: 'create_account'.tr,
                      isLoading: loading,
                      onPressed: () => _submit(context),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
