import 'package:flutter/material.dart';
import 'package:wallet/core/constants/colors.dart';

const String _font = 'Cairo-Bold';

// ─── Typography scale ──────────────────────────────────────────────────────────
// Display: 24 bold   | Headline: 20 bold  | Title: 16 semibold
// Body: 14 regular   | Body Small: 12 reg | Label: 11 medium | Caption: 10 reg

const TextTheme _textTheme = TextTheme(
  displayLarge: TextStyle(fontFamily: _font, fontSize: 24, fontWeight: FontWeight.w700, height: 1.3),
  displayMedium: TextStyle(fontFamily: _font, fontSize: 22, fontWeight: FontWeight.w700, height: 1.3),
  displaySmall: TextStyle(fontFamily: _font, fontSize: 20, fontWeight: FontWeight.w700, height: 1.3),
  headlineLarge: TextStyle(fontFamily: _font, fontSize: 20, fontWeight: FontWeight.w700, height: 1.35),
  headlineMedium: TextStyle(fontFamily: _font, fontSize: 18, fontWeight: FontWeight.w700, height: 1.35),
  headlineSmall: TextStyle(fontFamily: _font, fontSize: 16, fontWeight: FontWeight.w700, height: 1.4),
  titleLarge: TextStyle(fontFamily: _font, fontSize: 16, fontWeight: FontWeight.w600, height: 1.4),
  titleMedium: TextStyle(fontFamily: _font, fontSize: 15, fontWeight: FontWeight.w600, height: 1.4),
  titleSmall: TextStyle(fontFamily: _font, fontSize: 14, fontWeight: FontWeight.w600, height: 1.4),
  bodyLarge: TextStyle(fontFamily: _font, fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),
  bodyMedium: TextStyle(fontFamily: _font, fontSize: 13, fontWeight: FontWeight.w400, height: 1.5),
  bodySmall: TextStyle(fontFamily: _font, fontSize: 12, fontWeight: FontWeight.w400, height: 1.5),
  labelLarge: TextStyle(fontFamily: _font, fontSize: 12, fontWeight: FontWeight.w600, height: 1.4),
  labelMedium: TextStyle(fontFamily: _font, fontSize: 11, fontWeight: FontWeight.w500, height: 1.4),
  labelSmall: TextStyle(fontFamily: _font, fontSize: 10, fontWeight: FontWeight.w400, height: 1.4),
);

// ─── Shared input border radius ────────────────────────────────────────────────
OutlineInputBorder _inputBorder(Color color, {double width = 1}) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppColors.radiusMd),
      borderSide: BorderSide(color: color, width: width),
    );

// ─── Light Theme ──────────────────────────────────────────────────────────────
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: _font,
  brightness: Brightness.light,

  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.kPrimaryColor,
    onPrimary: Colors.white,
    primaryContainer: AppColors.kPrimaryLight,
    onPrimaryContainer: AppColors.kPrimaryDark,
    secondary: AppColors.kSecondColor,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.kSecondLight,
    onSecondaryContainer: Color(0xFF3730A3),
    error: AppColors.kRedColor,
    onError: Colors.white,
    surface: AppColors.kSurfaceLight,
    onSurface: AppColors.kTextPrimary,
    surfaceContainerHighest: AppColors.kBackgroundLight,
    onSurfaceVariant: AppColors.kTextSecondary,
    outline: AppColors.kBorderLight,
    outlineVariant: Color(0xFFF1F5F9),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppColors.kTextPrimary,
    onInverseSurface: Colors.white,
    inversePrimary: AppColors.kPrimaryLight,
  ),

  scaffoldBackgroundColor: AppColors.kBackgroundLight,

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.kSurfaceLight,
    foregroundColor: AppColors.kTextPrimary,
    elevation: 0,
    scrolledUnderElevation: 1,
    centerTitle: true,
    surfaceTintColor: Colors.transparent,
    shadowColor: Color(0x0A000000),
    titleTextStyle: TextStyle(
      fontFamily: _font,
      fontSize: 17,
      fontWeight: FontWeight.w700,
      color: AppColors.kTextPrimary,
    ),
    iconTheme: IconThemeData(color: AppColors.kTextPrimary, size: 22),
    actionsIconTheme: IconThemeData(color: AppColors.kTextPrimary, size: 22),
  ),

  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.kSurfaceLight,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.black12,
    elevation: 4,
    height: 64,
    indicatorColor: AppColors.kPrimaryColor.withValues(alpha: 0.12),
    indicatorShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      final selected = states.contains(WidgetState.selected);
      return TextStyle(
        fontFamily: _font,
        fontSize: 11,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        color: selected ? AppColors.kPrimaryColor : AppColors.kTextSecondary,
      );
    }),
    iconTheme: WidgetStateProperty.resolveWith((states) {
      final selected = states.contains(WidgetState.selected);
      return IconThemeData(
        color: selected ? AppColors.kPrimaryColor : AppColors.kTextSecondary,
        size: 22,
      );
    }),
  ),

  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppColors.radiusLg),
      side: const BorderSide(color: AppColors.kBorderLight),
    ),
    color: AppColors.kCardLight,
    surfaceTintColor: Colors.transparent,
  ),

  inputDecorationTheme: InputDecorationTheme(
    border: _inputBorder(AppColors.kBorderLight),
    enabledBorder: _inputBorder(AppColors.kBorderLight),
    focusedBorder: _inputBorder(AppColors.kPrimaryColor, width: 1.5),
    errorBorder: _inputBorder(AppColors.kRedColor),
    focusedErrorBorder: _inputBorder(AppColors.kRedColor, width: 1.5),
    filled: true,
    fillColor: AppColors.kSurfaceLight,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: const TextStyle(
      fontFamily: _font,
      color: AppColors.kTextDisabled,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    labelStyle: const TextStyle(
      fontFamily: _font,
      color: AppColors.kTextSecondary,
      fontSize: 14,
    ),
    errorStyle: const TextStyle(
      fontFamily: _font,
      color: AppColors.kRedColor,
      fontSize: 12,
    ),
  ),

  textTheme: _textTheme,

  chipTheme: ChipThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.radiusSm)),
    side: BorderSide.none,
    labelStyle: const TextStyle(fontFamily: _font, fontSize: 12, fontWeight: FontWeight.w600),
    backgroundColor: AppColors.kBackgroundLight,
    selectedColor: AppColors.kPrimaryColor.withValues(alpha: 0.12),
    checkmarkColor: AppColors.kPrimaryColor,
    labelPadding: const EdgeInsets.symmetric(horizontal: 4),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  ),

  dividerTheme: const DividerThemeData(
    color: AppColors.kBorderLight,
    thickness: 1,
    space: 1,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.kPrimaryColor,
      foregroundColor: Colors.white,
      disabledBackgroundColor: AppColors.kTextDisabled,
      disabledForegroundColor: Colors.white70,
      textStyle: const TextStyle(fontFamily: _font, fontWeight: FontWeight.w700, fontSize: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.radiusMd)),
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ).copyWith(
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) return Colors.white.withValues(alpha: 0.15);
        if (states.contains(WidgetState.hovered)) return Colors.white.withValues(alpha: 0.08);
        return null;
      }),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.kPrimaryColor,
      side: const BorderSide(color: AppColors.kBorderLight),
      textStyle: const TextStyle(fontFamily: _font, fontWeight: FontWeight.w600, fontSize: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.radiusMd)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.kPrimaryColor,
      textStyle: const TextStyle(fontFamily: _font, fontWeight: FontWeight.w600, fontSize: 14),
    ).copyWith(
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) return AppColors.kPrimaryColor.withValues(alpha: 0.1);
        if (states.contains(WidgetState.hovered)) return AppColors.kPrimaryColor.withValues(alpha: 0.05);
        return null;
      }),
    ),
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.kPrimaryColor,
    foregroundColor: Colors.white,
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),

  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.kSurfaceLight,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.radiusXl)),
    elevation: 8,
    titleTextStyle: const TextStyle(
      fontFamily: _font,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColors.kTextPrimary,
    ),
    contentTextStyle: const TextStyle(
      fontFamily: _font,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.kTextSecondary,
    ),
  ),

  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.kSurfaceLight,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppColors.radiusXl)),
    ),
    elevation: 8,
    dragHandleColor: AppColors.kBorderLight,
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.kTextPrimary,
    contentTextStyle: const TextStyle(
      fontFamily: _font,
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.radiusMd)),
    behavior: SnackBarBehavior.floating,
    elevation: 4,
  ),

  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      highlightColor: AppColors.kPrimaryColor.withValues(alpha: 0.1),
    ),
  ),
);

// ─── Dark Theme ───────────────────────────────────────────────────────────────
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: _font,
  brightness: Brightness.dark,

  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.kPrimaryColorDarkMode,
    onPrimary: Colors.white,
    primaryContainer: AppColors.kPrimaryDark,
    onPrimaryContainer: AppColors.kPrimaryLight,
    secondary: AppColors.kSecondColorDarkMode,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFF3730A3),
    onSecondaryContainer: AppColors.kSecondLight,
    error: Color(0xFFF87171),
    onError: AppColors.kTextPrimary,
    surface: AppColors.kSurfaceDark,
    onSurface: Color(0xFFF1F5F9),
    surfaceContainerHighest: AppColors.kBackgroundDark,
    onSurfaceVariant: Color(0xFF94A3B8),
    outline: AppColors.kBorderDark,
    outlineVariant: Color(0xFF1E293B),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFF1F5F9),
    onInverseSurface: AppColors.kTextPrimary,
    inversePrimary: AppColors.kPrimaryDark,
  ),

  scaffoldBackgroundColor: AppColors.kBackgroundDark,

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.kSurfaceDark,
    foregroundColor: Color(0xFFF1F5F9),
    elevation: 0,
    scrolledUnderElevation: 1,
    centerTitle: true,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.black26,
    titleTextStyle: TextStyle(
      fontFamily: _font,
      fontSize: 17,
      fontWeight: FontWeight.w700,
      color: Color(0xFFF1F5F9),
    ),
    iconTheme: IconThemeData(color: Color(0xFFF1F5F9), size: 22),
    actionsIconTheme: IconThemeData(color: Color(0xFFF1F5F9), size: 22),
  ),

  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.kSurfaceDark,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.black38,
    elevation: 4,
    height: 64,
    indicatorColor: AppColors.kPrimaryColorDarkMode.withValues(alpha: 0.18),
    indicatorShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      final selected = states.contains(WidgetState.selected);
      return TextStyle(
        fontFamily: _font,
        fontSize: 11,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        color: selected ? AppColors.kPrimaryColorDarkMode : const Color(0xFF64748B),
      );
    }),
    iconTheme: WidgetStateProperty.resolveWith((states) {
      final selected = states.contains(WidgetState.selected);
      return IconThemeData(
        color: selected ? AppColors.kPrimaryColorDarkMode : const Color(0xFF64748B),
        size: 22,
      );
    }),
  ),

  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppColors.radiusLg),
      side: const BorderSide(color: AppColors.kBorderDark),
    ),
    color: AppColors.kCardDark,
    surfaceTintColor: Colors.transparent,
  ),

  inputDecorationTheme: InputDecorationTheme(
    border: _inputBorder(AppColors.kBorderDark),
    enabledBorder: _inputBorder(AppColors.kBorderDark),
    focusedBorder: _inputBorder(AppColors.kPrimaryColorDarkMode, width: 1.5),
    errorBorder: _inputBorder(const Color(0xFFF87171)),
    focusedErrorBorder: _inputBorder(const Color(0xFFF87171), width: 1.5),
    filled: true,
    fillColor: AppColors.kSurfaceVariantDark,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: const TextStyle(
      fontFamily: _font,
      color: Color(0xFF64748B),
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    labelStyle: const TextStyle(
      fontFamily: _font,
      color: Color(0xFF94A3B8),
      fontSize: 14,
    ),
    errorStyle: const TextStyle(
      fontFamily: _font,
      color: Color(0xFFF87171),
      fontSize: 12,
    ),
  ),

  textTheme: _textTheme,

  chipTheme: ChipThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.radiusSm)),
    side: BorderSide.none,
    labelStyle: const TextStyle(fontFamily: _font, fontSize: 12, fontWeight: FontWeight.w600),
    backgroundColor: AppColors.kSurfaceVariantDark,
    selectedColor: AppColors.kPrimaryColorDarkMode.withValues(alpha: 0.2),
    checkmarkColor: AppColors.kPrimaryColorDarkMode,
    labelPadding: const EdgeInsets.symmetric(horizontal: 4),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  ),

  dividerTheme: const DividerThemeData(
    color: AppColors.kBorderDark,
    thickness: 1,
    space: 1,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.kPrimaryColorDarkMode,
      foregroundColor: Colors.white,
      disabledBackgroundColor: const Color(0xFF475569),
      disabledForegroundColor: Colors.white54,
      textStyle: const TextStyle(fontFamily: _font, fontWeight: FontWeight.w700, fontSize: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.radiusMd)),
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ).copyWith(
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) return Colors.white.withValues(alpha: 0.15);
        if (states.contains(WidgetState.hovered)) return Colors.white.withValues(alpha: 0.08);
        return null;
      }),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.kPrimaryColorDarkMode,
      side: const BorderSide(color: AppColors.kBorderDark),
      textStyle: const TextStyle(fontFamily: _font, fontWeight: FontWeight.w600, fontSize: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.radiusMd)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.kPrimaryColorDarkMode,
      textStyle: const TextStyle(fontFamily: _font, fontWeight: FontWeight.w600, fontSize: 14),
    ),
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.kPrimaryColorDarkMode,
    foregroundColor: Colors.white,
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),

  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.kSurfaceDark,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.radiusXl)),
    elevation: 8,
    titleTextStyle: const TextStyle(
      fontFamily: _font,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Color(0xFFF1F5F9),
    ),
    contentTextStyle: const TextStyle(
      fontFamily: _font,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Color(0xFF94A3B8),
    ),
  ),

  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.kSurfaceDark,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppColors.radiusXl)),
    ),
    elevation: 8,
    dragHandleColor: AppColors.kBorderDark,
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: const Color(0xFF1E293B),
    contentTextStyle: const TextStyle(
      fontFamily: _font,
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Color(0xFFF1F5F9),
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.radiusMd)),
    behavior: SnackBarBehavior.floating,
    elevation: 4,
  ),

  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      highlightColor: AppColors.kPrimaryColorDarkMode.withValues(alpha: 0.12),
    ),
  ),
);
