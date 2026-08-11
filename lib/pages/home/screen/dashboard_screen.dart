import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:wallet/core/components/app_text.dart';
import 'package:wallet/core/constants/colors.dart';
import 'package:wallet/core/constants/functions.dart';
import 'package:wallet/pages/home/cubit/dashboard_cubit.dart';
import 'package:wallet/pages/projects/screen/project_form_screen.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key, required this.onNavigate});

  /// Switches the shell's bottom-nav tab (1=Projects, 2=Tasks, 3=Notifications).
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
          onRefresh: () => context.read<DashboardCubit>().load(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            children: [
              _greeting(name),
              const SizedBox(height: 24),
              AppText('quick_actions'.tr, fontSize: 15),
              const SizedBox(height: 12),
              _quickActions(context),
              const SizedBox(height: 24),
              AppText('overview'.tr, fontSize: 15),
              const SizedBox(height: 12),
              _overview(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _greeting(String name) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [AppColors.kPrimaryColor, Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText('greeting'.tr, fontSize: 13, color: Colors.white70, fontWeight: FontWeight.w400),
          const SizedBox(height: 6),
          AppText(name, fontSize: 22, color: Colors.white, maxLines: 1),
          const SizedBox(height: 6),
          AppText('dashboard_subtitle'.tr,
              fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w400, maxLines: 2),
        ],
      ),
    );
  }

  Widget _quickActions(BuildContext context) {
    final actions = [
      _Qa(Icons.add_task_rounded, 'new_task'.tr, () => onNavigate(2)),
      _Qa(Icons.create_new_folder_outlined, 'new_project'.tr,
          () => Get.to(() => const ProjectFormScreen())),
      _Qa(Icons.folder_open_rounded, 'projects'.tr, () => onNavigate(1)),
      _Qa(Icons.notifications_none_rounded, 'notifications'.tr, () => onNavigate(3)),
    ];
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: actions
          .map((a) => InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: a.onTap,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(a.icon, color: AppColors.kPrimaryColor, size: 26),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AppText(a.label,
                            fontSize: 10, textAlign: TextAlign.center, maxLines: 2),
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _overview(BuildContext context, DashboardState s) {
    Widget card(IconData icon, String label, int value, Color color, VoidCallback onTap) {
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.kGreyColor.withOpacity(0.12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(height: 10),
                AppText(s.loading ? '—' : '$value', fontSize: 20, color: color),
                const SizedBox(height: 2),
                AppText(label,
                    fontSize: 11, color: AppColors.kGreyColor, fontWeight: FontWeight.w500, maxLines: 1),
              ],
            ),
          ),
        ),
      );
    }

    return Column(children: [
      Row(children: [
        card(Icons.folder_open_rounded, 'active_projects'.tr, s.activeProjects,
            AppColors.kStatusInProgress, () => onNavigate(1)),
        const SizedBox(width: 12),
        card(Icons.pending_actions_rounded, 'pending_tasks'.tr, s.pendingTasks,
            AppColors.kWarningColor, () => onNavigate(2)),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        card(Icons.notifications_active_outlined, 'unread_notifications'.tr,
            s.unreadNotifications, AppColors.kPrimaryColor, () => onNavigate(3)),
        const SizedBox(width: 12),
        const Expanded(child: SizedBox()),
      ]),
    ]);
  }
}

class _Qa {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  _Qa(this.icon, this.label, this.onTap);
}
