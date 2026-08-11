import 'package:flutter/material.dart';

typedef AppColor = AppColors;

class AppColors {
  // 💼 Brand (Calm Modern Indigo / Blue — technology-focused startup)
  static const Color kPrimaryColor = Color(0xFF4F46E5); // deep indigo
  static const Color kSecondColor = Color(0xFF14B8A6); // muted teal
  static const Color kThirdColor = Color(0xFFEEF2FF); // very light indigo tint

  // Dark Mode Brand
  static const Color kPrimaryColorDarkMode = Color(0xFF6366F1);
  static const Color kSecondColorDarkMode = Color(0xFF2DD4BF);
  static const Color kThirdColorDarkMode = Color(0xFF1E1B4B);

  // ─── Task Status Colors ──────────────────────────────────────────────────
  static const Color kStatusNotStarted = Color(0xFF94A3B8);
  static const Color kStatusInProgress = Color(0xFF3B82F6);
  static const Color kStatusCompleted = Color(0xFF22C55E);
  static const Color kStatusOverdue = Color(0xFFEF4444);
  static const Color kStatusDeferred = Color(0xFFF59E0B);

  // ─── Task Priority Colors ────────────────────────────────────────────────
  static const Color kPriorityLow = Color(0xFF22C55E);
  static const Color kPriorityMedium = Color(0xFFF59E0B);
  static const Color kPriorityHigh = Color(0xFFEF4444);
  static const Color kPriorityUrgent = Color(0xFF7C3AED);

  // ─── Neutral ─────────────────────────────────────────────────────────────
  static const Color kGreyColor = Color(0xFF64748B);
  static const Color kFontColor = Color(0xFF111827);
  static const Color kRedColor = Color(0xFFEF4444);
  static const Color kBlackColor = Color(0xFF111827);
  static const Color kWhiteColor = Colors.white;
  static const Color kSuccessColor = Color(0xFF22C55E);
  static const Color kWarningColor = Color(0xFFF59E0B);
  static const Color kBackgroundLight = Color(0xFFF8F9FA);
  static const Color kBackgroundDark = Color(0xFF0F172A);
  static const Color kCardDark = Color(0xFF1E293B);
  static const Color kSurfaceDark = Color(0xFF263040);
}
