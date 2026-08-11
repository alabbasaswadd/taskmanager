import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:wallet/core/constants/functions.dart';
import 'package:wallet/core/push/devices_repository.dart';
import 'package:wallet/pages/notifications/notification_navigator.dart';

/// Background isolate handler. Must be a top-level function. Data-only work here
/// (the OS renders the notification tray entry for background/terminated apps).
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  // Intentionally minimal: deep-link handling happens on tap (onMessageOpenedApp).
  debugPrint('FCM background message: ${message.messageId}');
}

/// Encapsulates all FCM concerns: initialization, permission, token
/// registration/refresh, foreground display, and tap → deep-link navigation.
/// This is the ONLY push infrastructure — do not duplicate it.
///
/// ⚠️ Requires Firebase client config (google-services.json / firebase_options)
/// via `flutterfire configure`. Until then [initialize] no-ops gracefully and
/// the app runs normally (in-app notification center still works over REST).
class PushNotificationService {
  const PushNotificationService._();

  static final DevicesRepository _devices = DevicesRepository();
  static bool _available = false;

  /// Call once at startup (before/around runApp). Safe if Firebase is unconfigured.
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

      FirebaseMessaging.onMessage.listen(_onForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageTapped);
      FirebaseMessaging.instance.onTokenRefresh.listen(_registerToken);

      // Cold start from a notification tap.
      final initial = await FirebaseMessaging.instance.getInitialMessage();
      if (initial != null) _onMessageTapped(initial);

      _available = true;
    } catch (e) {
      _available = false;
      debugPrint('FCM disabled (Firebase not configured): $e');
    }
  }

  /// Call AFTER successful login: ask permission (once) and register the token.
  static Future<void> requestPermissionAndRegister() async {
    if (!_available) return;
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      // Denied / permanently denied → do not re-prompt or register.
      if (settings.authorizationStatus == AuthorizationStatus.denied ||
          settings.authorizationStatus == AuthorizationStatus.notDetermined) {
        return;
      }
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) await _registerToken(token);
    } catch (e) {
      debugPrint('FCM permission/registration failed: $e');
    }
  }

  static Future<void> _registerToken(String token) async {
    if (!UserSession.isLoggedIn) return;
    final platform = defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';
    await _devices.registerDevice(token: token, platform: platform);
  }

  static void _onForegroundMessage(RemoteMessage message) {
    final n = message.notification;
    if (n == null) return;
    // Lightweight in-app banner (no extra plugin). Tap opens the referenced entity.
    Get.snackbar(
      n.title ?? '',
      n.body ?? '',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      onTap: (_) => _openFromData(message.data),
    );
  }

  static void _onMessageTapped(RemoteMessage message) => _openFromData(message.data);

  static void _openFromData(Map<String, dynamic> data) {
    NotificationNavigator.open(
      referenceType: data['referenceType']?.toString(),
      referenceId: data['referenceId']?.toString(),
    );
  }
}
