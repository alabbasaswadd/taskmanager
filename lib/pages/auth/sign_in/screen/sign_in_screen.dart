import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wallet/core/components/app_button.dart';
import 'package:wallet/core/components/app_text.dart';
import 'package:wallet/core/components/app_text_form_field.dart';
import 'package:wallet/core/constants/colors.dart';
import 'package:wallet/pages/auth/sign_up/screen/sign_up_screen.dart';
import 'package:wallet/pages/home/screen/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static String id = "/sign-in";

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'field_required'.tr;
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v.trim())) return 'email_invalid'.tr;
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'field_required'.tr;
    if (v.length < 6) return 'password_min_length'.tr;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h),

                // ─── Logo ──────────────────────────────────────────────────
                Container(
                  width: 80.w,
                  height: 80.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.kPrimaryColor, AppColors.kSecondColor],
                    ),
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.kPrimaryColor.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(Icons.task_alt_rounded, size: 44.sp, color: Colors.white),
                ),
                SizedBox(height: 24.h),
                AppText(
                  'welcome_back'.tr,
                  textAlign: TextAlign.center,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 8.h),
                AppText(
                  'sign_in_to_continue'.tr,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.kGreyColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 36.h),

                // ─── Fields ────────────────────────────────────────────────
                AppTextFormField(
                  controller: _emailController,
                  label: 'email'.tr,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                SizedBox(height: 16.h),
                AppTextFormField(
                  controller: _passwordController,
                  label: 'password'.tr,
                  obscureText: _obscurePassword,
                  validator: _validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                SizedBox(height: 32.h),

                AppButton(
                  text: 'sign_in'.tr,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Get.offAllNamed(HomeScreen.id);
                    }
                  },
                ),
                SizedBox(height: 24.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText('dont_have_account'.tr, style: TextStyle(fontSize: 14.sp)),
                    TextButton(
                      onPressed: () => Get.toNamed(SignUpScreen.id),
                      child: AppText('sign_up'.tr, color: AppColors.kPrimaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
