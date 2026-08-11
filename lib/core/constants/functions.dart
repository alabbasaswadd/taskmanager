import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wallet/pages/auth/sign_in/model/signin_model.dart';
import 'package:wallet/pages/auth/sign_in/model/signin_response_model.dart';
import 'package:wallet/pages/auth/sign_in/model/user_model.dart';

// void initFCM() async {
//   // FirebaseMessaging messaging = FirebaseMessaging.instance;

//   await messaging.requestPermission();

//   // الحصول على التوكن
//   String? token = await messaging.getToken();
//   CacheHelper.setString("tokenFCM", token ?? "");
//   print("TOKEN: $token");
// }

class UserPreferencesService {
  static const String _signinKey = 'signin_data';

  /// حفظ بيانات تسجيل الدخول كاملة
  static Future<void> saveSigninData(SigninModel signinModel) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_signinKey, jsonEncode(signinModel.toJson()));
  }

  /// جلب بيانات تسجيل الدخول
  static Future<SigninModel?> getSigninData() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(_signinKey);

    if (data == null) return null;

    return SigninModel.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  /// حذف البيانات
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_signinKey);
  }

  /// جلب التوكن
  static Future<String?> getToken() async {
    final signinData = await getSigninData();
    return signinData?.token;
  }

  /// التحقق من تسجيل الدخول
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

class UserSession {
  static SigninModel? _signinModel;

  /// تحميل الجلسة
  static Future<void> init() async {
    _signinModel = await UserPreferencesService.getSigninData();
  }

  /// البيانات الكاملة
  static SigninModel? get signinModel => _signinModel;

  /// المستخدم
  static UserModel? get user => _signinModel?.user;

  /// التوكن
  static String? get token => _signinModel?.token;

  /// خصائص مختصرة
  static String? get id => user?.id;
  static String? get fullName => user?.name;
  static String? get displayName => user?.displayName ?? user?.name;
  static String? get email => user?.email;
  static bool get isActive => user?.isActive ?? false;
  static String? get firstName => user?.firstName;
  static String? get lastName => user?.lastName;

  /// هل يوجد جلسة
  static bool get isLoggedIn =>
      _signinModel?.token != null && _signinModel!.token!.isNotEmpty;

  /// تحديث الجلسة كاملة
  static Future<void> updateSession(SigninResponseModel signinModel) async {
    _signinModel = signinModel.data;

    await UserPreferencesService.saveSigninData(signinModel.data!);
  }

  /// تحديث المستخدم فقط
  static Future<void> updateUser(UserModel userModel) async {
    if (_signinModel == null) return;

    _signinModel = SigninModel(token: _signinModel!.token, user: userModel);

    await UserPreferencesService.saveSigninData(_signinModel!);
  }

  /// تسجيل الخروج
  static Future<void> clear() async {
    _signinModel = null;
    await UserPreferencesService.clear();
  }
}
