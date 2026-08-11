import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:wallet/core/components/app_text.dart';
import 'package:wallet/core/constants/colors.dart';
import 'package:wallet/core/constants/functions.dart';
import 'package:wallet/pages/home/cubit/dashboard_cubit.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key, required this.onNavigate});

  final void Function(int index) onNavigate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit()..load(),
      child: _DashboardView(onNavigate: onNavigate),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView({required this.onNavigate});
  final void Function(int index) onNavigate;

  @override
  Widget build(BuildContext context) {
    final name = UserSession.displayName ?? UserSession.firstName ?? 'account'.tr;
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          onRefresh: () => context.read<DashboardCubit>().load(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            children: [
              _greeting(context, name),
              const SizedBox(height: 24),
              _sectionLabel(context, 'overview'.tr),
              const SizedBox(height: 12),
              _overviewRow(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionLabel(BuildContext context, String label) {
    return AppText(
      label,
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  Widget _greeting(BuildContext context, String name) {
    final hour = DateTime.now().hour;
    final String timeGreeting;
    if (hour < 12) {
      timeGreeting = 'good_morning'.tr;
    } else if (hour < 17) {
      timeGreeting = 'good_afternoon'.tr;
    } else {
      timeGreeting = 'good_evening'.tr;
    }

    final primary = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientEnd = isDark ? AppColors.kPrimaryDark : const Color(0xFFA21CAF);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppColors.radiusXl),
        gradient: LinearGradient(
          colors: [primary, gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            timeGreeting,
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.8),
            fontWeight: FontWeight.w400,
          ),
          const SizedBox(height: 6),
          AppText(name, fontSize: 22, color: Colors.white, maxLines: 1),
          const SizedBox(height: 6),
          AppText(
            'dashboard_subtitle'.tr,
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.75),
            fontWeight: FontWeight.w400,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _overviewRow(BuildContext context, DashboardState s) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget card(IconData icon, String label, int value, Color color, VoidCallback onTap) {
      return Expanded(
        child: Material(
          color: Theme.of(context).cardTheme.color ?? colorScheme.surface,
          borderRadius: BorderRadius.circular(AppColors.radiusLg),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppColors.radiusLg),
            highlightColor: Colors.transparent,
            splashColor: color.withValues(alpha: 0.1),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppColors.radiusLg),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppColors.radiusSm),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(height: 12),
                  AppText(
                    s.loading ? '–' : '$value',
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                  const SizedBox(height: 3),
                  AppText(
                    label,
                    fontSize: 11,
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        card(
          Icons.folder_open_rounded,
          'active_projects'.tr,
          s.activeProjects,
          AppColors.kStatusInProgress,
          () => onNavigate(1),
        ),
        const SizedBox(width: 12),
        card(
          Icons.pending_actions_rounded,
          'pending_tasks'.tr,
          s.pendingTasks,
          AppColors.kWarningColor,
          () => onNavigate(2),
        ),
      ],
    );
  }
}
