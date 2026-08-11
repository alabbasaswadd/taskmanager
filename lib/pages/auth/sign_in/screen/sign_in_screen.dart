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
import 'package:wallet/pages/auth/sign_up/screen/register_screen.dart';
import 'package:wallet/pages/main/main_shell.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});
  static const String id = "/login";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: const _SignInView(),
    );
  }
}

class _SignInView extends StatefulWidget {
  const _SignInView();
  @override
  State<_SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<_SignInView> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(_email.text, _password.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 84.r,
                        width: 84.r,
                        decoration: BoxDecoration(
                          color: AppColors.kPrimaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.workspaces_rounded,
                            size: 42, color: AppColors.kPrimaryColor),
                      ),
                      SizedBox(height: 20.h),
                      AppText('app_name'.tr, fontSize: 24, textAlign: TextAlign.center),
                      SizedBox(height: 6.h),
                      AppText('login_subtitle'.tr,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.kGreyColor,
                          textAlign: TextAlign.center,
                          maxLines: 2),
                      SizedBox(height: 28.h),
                      AppTextFormField(
                        label: 'email'.tr,
                        controller: _email,
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (v) => (v == null || !v.contains('@'))
                            ? 'validation_email'.tr
                            : null,
                      ),
                      SizedBox(height: 4.h),
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
                        validator: (v) => (v == null || v.length < 4)
                            ? 'validation_password'.tr
                            : null,
                      ),
                      SizedBox(height: 24.h),
                      AppButton(
                        text: 'login'.tr,
                        isLoading: loading,
                        onPressed: () => _submit(context),
                      ),
                      SizedBox(height: 12.h),
                      TextButton(
                        onPressed: loading ? null : () => Get.to(() => const RegisterScreen()),
                        child: AppText('dont_have_account_create'.tr,
                            fontSize: 13, color: AppColors.kPrimaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
