import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import 'app_animation.dart';
import 'app_text.dart';

class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    super.key,
    required this.onOk,
    required this.onNo,
    required this.title,
    required this.content,
    this.icon,
    this.iconColor,
    this.okLabel,
    this.noLabel,
  });

  final VoidCallback onOk;
  final VoidCallback onNo;
  final String title;
  final String content;
  final IconData? icon;
  final Color? iconColor;
  final String? okLabel;
  final String? noLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveIconColor = iconColor ?? AppColors.kPrimaryColor;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: isDark ? AppColors.kCardDark : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.12),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top accent bar
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon badge
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: effectiveIconColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon ?? Icons.help_outline_rounded,
                      color: effectiveIconColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  AppText(
                    title,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                    color: colorScheme.onSurface,
                  ),
                  const SizedBox(height: 10),

                  // Content
                  AppText(
                    content,
                    maxLines: 5,
                    textAlign: TextAlign.center,
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.6),
                    height: 1.6,
                  ),
                  const SizedBox(height: 28),

                  // Action buttons
                  Row(
                    children: [
                      // Cancel button
                      Expanded(
                        child: AppAnimation(
                          scale: 0.95,
                          child: _OutlineButton(
                            label: noLabel ?? "لا".tr,
                            onPressed: onNo,
                            isDark: isDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Confirm button
                      Expanded(
                        child: AppAnimation(
                          scale: 0.95,
                          child: _FilledButton(
                            label: okLabel ?? "نعم".tr,
                            onPressed: onOk,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilledButton extends StatelessWidget {
  const _FilledButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.kPrimaryColor, AppColors.kSecondColor],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.kPrimaryColor.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: AppText(
          label,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({
    required this.label,
    required this.onPressed,
    required this.isDark,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : AppColors.kGreyColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.12)
                : AppColors.kGreyColor.withOpacity(0.25),
          ),
        ),
        alignment: Alignment.center,
        child: AppText(
          label,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : AppColors.kGreyColor,
        ),
      ),
    );
  }
}
