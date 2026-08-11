// import 'dart:convert';

// import 'package:exchange_admin/core/constants/cached/cached_helper.dart';
// import 'package:exchange_admin/pages/features/account/model/account_model.dart';

// class UserSession {
//   UserSession._();

//   /// =========================
//   /// Keys
//   /// =========================
//   static const String _userKey = 'cached_user_data';
//   static const String _tokenKey = 'cached_user_token';
//   static const String _isLoggedInKey = 'cached_is_logged_in';

//   /// In-memory cache — populated by [init] or [saveUser].
//   static AccountModel? _user;

//   /// Synchronous access to the loaded user.
//   /// Call [init] once at app startup before using this getter.
//   static AccountModel? get user => _user;

//   /// =========================
//   /// Init — load from cache
//   /// =========================
//   /// Call once at app startup (e.g. in main or StartupCubit) so that
//   /// [user] and all synchronous getters are available without await.
//   static Future<void> init() async {
//     _user = await _loadFromCache();
//   }

//   static Future<AccountModel?> _loadFromCache() async {
//     final jsonString = await CacheHelper.getString(_userKey);
//     if (jsonString.isEmpty) return null;
//     try {
//       return AccountModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
//     } catch (_) {
//       return null;
//     }
//   }

//   /// =========================
//   /// Save Full User Session
//   /// =========================
//   static Future<void> saveUser(AccountModel user) async {
//     _user = user;
//     await CacheHelper.setString(_userKey, jsonEncode(user.toJson()));
//     await CacheHelper.setString(_tokenKey, user.token);
//     await CacheHelper.setBool(_isLoggedInKey, true);
//   }

//   /// =========================
//   /// Get Full User Model
//   /// =========================
//   static Future<AccountModel?> getUser() async {
//     _user ??= await _loadFromCache();
//     return _user;
//   }

//   /// =========================
//   /// Basic User Info
//   /// =========================
//   static Future<String> getToken() async {
//     return await CacheHelper.getString(_tokenKey);
//   }

//   static Future<String> getUserId() async {
//     final u = await getUser();
//     return u?.id ?? "";
//   }

//   static Future<String> getAccountId() async {
//     final u = await getUser();
//     return u?.accountId ?? "";
//   }

//   static Future<String> getFirstName() async {
//     final u = await getUser();
//     return u?.firstName ?? "";
//   }

//   static Future<String> getLastName() async {
//     final u = await getUser();
//     return u?.lastName ?? "";
//   }

//   static Future<String> getFullName() async {
//     final u = await getUser();
//     if (u == null) return "";
//     return "${u.firstName ?? ''} ${u.lastName ?? ''}".trim();
//   }

//   static Future<bool> isActive() async {
//     final u = await getUser();
//     return u?.isActive ?? false;
//   }

//   static Future<bool> isLoggedIn() async {
//     return await CacheHelper.getBool(_isLoggedInKey) ?? false;
//   }

//   /// =========================
//   /// Subscription Helpers
//   /// =========================
//   // static Future<SubscriptionModel?> getCurrentSubscription() async {
//   //   final user = await getUser();

//   //   if (user == null || user.subscriptions.isEmpty) {
//   //     return null;
//   //   }

//   //   /// آخر اشتراك
//   //   return user.subscriptions.last;
//   // }

//   // static Future<String> getCurrentSubscriptionName() async {
//   //   final subscription = await getCurrentSubscription();
//   //   return subscription?.name ?? "";
//   // }

//   // static Future<DateTime?> getSubscriptionEndDate() async {
//   //   final subscription = await getCurrentSubscription();
//   //   return subscription?.endDate;
//   // }

//   /// =========================
//   /// Update User Data
//   /// =========================
//   static Future<void> updateUser(AccountModel updatedUser) async {
//     await saveUser(updatedUser);
//   }

//   /// =========================
//   /// Logout
//   /// =========================
//   static Future<void> logout() async {
//     _user = null;
//     await Future.wait([
//       CacheHelper.remove(_userKey),
//       CacheHelper.remove(_tokenKey),
//       CacheHelper.remove('token'),
//       CacheHelper.setBool(_isLoggedInKey, false),
//     ]);
//   }

//   /// =========================
//   /// Clear All Session
//   /// =========================
//   static Future<void> clearSession() async {
//     _user = null;
//     await Future.wait([
//       CacheHelper.remove(_userKey),
//       CacheHelper.remove(_tokenKey),
//       CacheHelper.remove('token'),
//       CacheHelper.remove(_isLoggedInKey),
//     ]);
//   }
// }
