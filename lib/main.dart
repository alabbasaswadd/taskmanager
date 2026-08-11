import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:wallet/core/constants/functions.dart';
import 'package:wallet/core/constants/theme.dart';
import 'package:wallet/core/localization/app_translations.dart';
import 'package:wallet/core/networking/dio_factory.dart';
import 'package:wallet/pages/auth/sign_in/screen/sign_in_screen.dart';
import 'package:wallet/pages/main/main_shell.dart';
import 'package:wallet/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Bootstrap: restore session → configure Dio token → wire 401 handling.
  await UserSession.init();
  if (UserSession.isLoggedIn) {
    DioFactory.setTokenIntoHeaderAfterLogin(UserSession.token);
  }
  DioFactory.onUnauthorized = _handleSessionExpired;

  runApp(
    ScreenUtilInit(
      designSize: const Size(392, 825),
      minTextAdapt: true,
      builder: (context, child) => MyApp(isLoggedIn: UserSession.isLoggedIn),
    ),
  );
}

/// Centralized session-expiry: clear session, drop token, return to login once.
void _handleSessionExpired() {
  UserSession.clear();
  DioFactory.clearToken();
  final current = Get.currentRoute;
  if (current != SignInScreen.id) {
    Get.offAllNamed(SignInScreen.id);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLoggedIn});
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: lightTheme,
      dark: darkTheme,
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => GetMaterialApp(
        translations: AppTranslations(),
        locale: const Locale('ar'),
        fallbackLocale: const Locale('en'),
        localizationsDelegates: const [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar', ''), Locale('en', '')],
        theme: theme,
        darkTheme: darkTheme,
        routes: routes,
        debugShowCheckedModeBanner: false,
        initialRoute: isLoggedIn ? MainShell.id : SignInScreen.id,
      ),
    );
  }
}
