import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/core/constants/colors.dart';
import 'package:wallet/core/constants/functions.dart';
import 'package:wallet/pages/auth/sign_in/screen/sign_in_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final name = UserSession.fullName ?? 'account'.tr;
    final email = UserSession.email ?? '';

    return Drawer(
      backgroundColor: isDark ? AppColors.kCardDark : AppColors.kWhiteColor,
      child: SafeArea(
        child: Column(
          children: [
            // ─── Header ───────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.kPrimaryColor, AppColors.kSecondColor],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (email.isNotEmpty)
                    Text(
                      email,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ─── Menu Items ───────────────────────────────────────────────
            _DrawerItem(
              icon: Icons.dashboard_outlined,
              title: 'home'.tr,
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.task_outlined,
              title: 'tasks'.tr,
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.folder_outlined,
              title: 'projects'.tr,
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.calendar_month_outlined,
              title: 'calendar'.tr,
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.person_outline_rounded,
              title: 'profile'.tr,
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.settings_outlined,
              title: 'settings'.tr,
              onTap: () => Navigator.pop(context),
            ),

            const Spacer(),
            const Divider(indent: 20, endIndent: 20),
            _DrawerItem(
              icon: Icons.logout_rounded,
              title: 'log_out'.tr,
              iconColor: AppColors.kRedColor,
              textColor: AppColors.kRedColor,
              onTap: () {
                Navigator.pop(context);
                UserSession.clear();
                Get.offAllNamed(SignInScreen.id);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.kPrimaryColor, size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
    );
  }
}
