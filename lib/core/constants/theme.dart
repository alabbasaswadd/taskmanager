import 'package:flutter/material.dart';
import 'package:wallet/core/constants/colors.dart';

const String _font = 'Cairo-Bold';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: _font,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.kPrimaryColor,
    brightness: Brightness.light,
    primary: AppColors.kPrimaryColor,
    secondary: AppColors.kSecondColor,
  ),
  scaffoldBackgroundColor: AppColors.kBackgroundLight,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: AppColors.kFontColor,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: _font,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.kFontColor,
    ),
    surfaceTintColor: Colors.transparent,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: AppColors.kPrimaryColor,
    unselectedItemColor: AppColors.kGreyColor,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    selectedLabelStyle: TextStyle(fontFamily: _font, fontSize: 11, fontWeight: FontWeight.w600),
    unselectedLabelStyle: TextStyle(fontFamily: _font, fontSize: 11),
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
    ),
    color: Colors.white,
    surfaceTintColor: Colors.transparent,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.kPrimaryColor, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.kRedColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.kRedColor, width: 1.5),
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: TextStyle(fontFamily: _font, color: AppColors.kGreyColor.withValues(alpha: 0.6), fontSize: 14),
    labelStyle: const TextStyle(fontFamily: _font, color: AppColors.kGreyColor, fontSize: 14),
    errorStyle: const TextStyle(fontFamily: _font, color: AppColors.kRedColor, fontSize: 12),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontFamily: _font, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontFamily: _font, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(fontFamily: _font, fontWeight: FontWeight.bold),
    headlineLarge: TextStyle(fontFamily: _font, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontFamily: _font, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(fontFamily: _font, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(fontFamily: _font, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontFamily: _font, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontFamily: _font, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontFamily: _font),
    bodyMedium: TextStyle(fontFamily: _font),
    bodySmall: TextStyle(fontFamily: _font),
    labelLarge: TextStyle(fontFamily: _font, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(fontFamily: _font),
    labelSmall: TextStyle(fontFamily: _font),
  ),
  chipTheme: ChipThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    side: BorderSide.none,
    labelStyle: const TextStyle(fontFamily: _font, fontSize: 12),
  ),
  dividerTheme: const DividerThemeData(color: Color(0xFFE2E8F0), thickness: 1),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.kPrimaryColor,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontFamily: _font, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.kPrimaryColor,
      textStyle: const TextStyle(fontFamily: _font, fontWeight: FontWeight.w600),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.kPrimaryColor,
    foregroundColor: Colors.white,
    elevation: 4,
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: _font,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.kPrimaryColor,
    brightness: Brightness.dark,
    primary: AppColors.kPrimaryColor,
  ),
  scaffoldBackgroundColor: AppColors.kBackgroundDark,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.kCardDark,
    foregroundColor: AppColors.kWhiteColor,
    elevation: 0,
    centerTitle: true,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: const TextStyle(
      fontFamily: _font,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.kWhiteColor,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.kCardDark,
    selectedItemColor: AppColors.kPrimaryColor,
    unselectedItemColor: AppColors.kGreyColor,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    selectedLabelStyle: const TextStyle(fontFamily: _font, fontSize: 11, fontWeight: FontWeight.w600),
    unselectedLabelStyle: const TextStyle(fontFamily: _font, fontSize: 11),
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: Color(0xFF2D3748), width: 1),
    ),
    color: AppColors.kCardDark,
    surfaceTintColor: Colors.transparent,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF2D3748)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF2D3748)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.kPrimaryColor, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.kRedColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.kRedColor, width: 1.5),
    ),
    filled: true,
    fillColor: AppColors.kSurfaceDark,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: TextStyle(fontFamily: _font, color: AppColors.kGreyColor.withValues(alpha: 0.7), fontSize: 14),
    labelStyle: const TextStyle(fontFamily: _font, color: AppColors.kGreyColor, fontSize: 14),
    errorStyle: const TextStyle(fontFamily: _font, color: AppColors.kRedColor, fontSize: 12),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontFamily: _font, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontFamily: _font, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(fontFamily: _font, fontWeight: FontWeight.bold),
    headlineLarge: TextStyle(fontFamily: _font, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontFamily: _font, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(fontFamily: _font, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(fontFamily: _font, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontFamily: _font, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontFamily: _font, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontFamily: _font),
    bodyMedium: TextStyle(fontFamily: _font),
    bodySmall: TextStyle(fontFamily: _font),
    labelLarge: TextStyle(fontFamily: _font, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(fontFamily: _font),
    labelSmall: TextStyle(fontFamily: _font),
  ),
  chipTheme: ChipThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    side: BorderSide.none,
    labelStyle: const TextStyle(fontFamily: _font, fontSize: 12),
  ),
  dividerTheme: const DividerThemeData(color: Color(0xFF2D3748), thickness: 1),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.kPrimaryColor,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontFamily: _font, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.kPrimaryColor,
      textStyle: const TextStyle(fontFamily: _font, fontWeight: FontWeight.w600),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.kPrimaryColor,
    foregroundColor: Colors.white,
    elevation: 4,
  ),
);
