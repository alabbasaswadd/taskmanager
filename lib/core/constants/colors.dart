import 'package:flutter/material.dart';

typedef AppColor = AppColors;

class AppColors {
  // ─── Brand ────────────────────────────────────────────────────────────────
  static const Color kPrimaryColor = Color(0xFFDB2777); // Pink 600
  static const Color kPrimaryLight = Color(0xFFFCE7F3); // Pink 50 tint
  static const Color kPrimaryDark = Color(0xFF9D174D); // Pink 800

  static const Color kSecondColor = Color(0xFF6366F1); // Indigo 500 — secondary
  static const Color kSecondLight = Color(0xFFEEF2FF); // Indigo 50 tint

  // Dark-mode brand variants
  static const Color kPrimaryColorDarkMode = Color(0xFFF472B6); // Pink 400
  static const Color kSecondColorDarkMode = Color(0xFF818CF8); // Indigo 400

  // ─── Background & Surface ─────────────────────────────────────────────────
  static const Color kBackgroundLight = Color(0xFFF1F5F9); // Slate 100
  static const Color kBackgroundDark = Color(0xFF0F172A); // Slate 900

  static const Color kSurfaceLight = Color(0xFFFFFFFF); // Pure white
  static const Color kSurfaceDark = Color(0xFF1E293B); // Slate 800

  static const Color kCardLight = Color(0xFFFFFFFF); // White
  static const Color kCardDark = Color(0xFF1E293B); // Slate 800

  static const Color kSurfaceVariantDark = Color(0xFF263040); // Slate 800.5

  // ─── Text ─────────────────────────────────────────────────────────────────
  static const Color kTextPrimary = Color(0xFF0F172A); // Slate 900
  static const Color kTextSecondary = Color(0xFF475569); // Slate 600
  static const Color kTextDisabled = Color(0xFF94A3B8); // Slate 400

  // Legacy aliases
  static const Color kFontColor = kTextPrimary;
  static const Color kBlackColor = kTextPrimary;
  static const Color kGreyColor = kTextSecondary;
  static const Color kWhiteColor = Colors.white;

  // ─── Border & Divider ─────────────────────────────────────────────────────
  static const Color kBorderLight = Color(0xFFE2E8F0); // Slate 200
  static const Color kBorderDark = Color(0xFF334155); // Slate 700

  static const Color kDividerLight = Color(0xFFF1F5F9); // Slate 100
  static const Color kDividerDark = Color(0xFF1E293B); // Slate 800

  // ─── Semantic ─────────────────────────────────────────────────────────────
  static const Color kSuccessColor = Color(0xFF16A34A); // Green 600
  static const Color kWarningColor = Color(0xFFD97706); // Amber 600
  static const Color kRedColor = Color(0xFFDC2626); // Red 600
  static const Color kInfoColor = Color(0xFF2563EB); // Blue 600

  // ─── Task Status ──────────────────────────────────────────────────────────
  static const Color kStatusNotStarted = Color(0xFF94A3B8); // Slate 400
  static const Color kStatusInProgress = Color(0xFF2563EB); // Blue 600
  static const Color kStatusCompleted = Color(0xFF16A34A); // Green 600
  static const Color kStatusOverdue = Color(0xFFDC2626); // Red 600
  static const Color kStatusDeferred = Color(0xFFD97706); // Amber 600

  // ─── Task Priority ────────────────────────────────────────────────────────
  static const Color kPriorityLow = Color(0xFF16A34A); // Green 600
  static const Color kPriorityMedium = Color(0xFFD97706); // Amber 600
  static const Color kPriorityHigh = Color(0xFFDC2626); // Red 600
  static const Color kPriorityUrgent = Color(0xFF7C3AED); // Violet 600

  // ─── Design Tokens ────────────────────────────────────────────────────────
  static const double radiusXs = 6;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radiusFull = 100;

  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 12;
  static const double spacingLg = 16;
  static const double spacingXl = 24;
  static const double spacingXxl = 32;
}
