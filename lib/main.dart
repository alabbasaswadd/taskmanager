import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallet/core/constants/theme.dart';
import 'package:wallet/core/localization/app_translations.dart';
import 'package:wallet/pages/home/screen/home_screen.dart';
import 'package:wallet/routes.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    ScreenUtilInit(
      designSize: const Size(392, 825),
      minTextAdapt: true,
      builder: (context, child) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        initialRoute: HomeScreen.id,
      ),
    );
  }
}
