import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

import 'package:wallet/core/components/shimmer_widgets.dart';
import 'package:wallet/core/constants/colors.dart';
import 'package:wallet/core/constants/functions.dart';
import 'package:wallet/core/enums/domain_enums.dart';
import 'package:wallet/core/state/paged_list_state.dart';
import 'package:wallet/pages/taskes/cubit/tasks_cubit.dart';
import 'package:wallet/pages/taskes/model/task_item_model.dart';
import 'package:wallet/pages/taskes/screen/task_details_screen.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key, required this.onNavigate});
  final void Function(int index) onNavigate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, PagedListState<TaskItemModel>>(
      buildWhen: (p, c) =>
          p.status != c.status || p.items != c.items || p.totalCount != c.totalCount,
      builder: (context, state) {
        if (state.isInitialLoading) return const DashboardShimmer();
        return _DashboardScroll(state: state, onNavigate: onNavigate);
      },
    );
  }
}

// ─── Main scroll view ─────────────────────────────────────────────────────────

class _DashboardScroll extends StatelessWidget {
  const _DashboardScroll({required this.state, required this.onNavigate});
  final PagedListState<TaskItemModel> state;
  final void Function(int) onNavigate;

  static const _max = 5;

  @override
  Widget build(BuildContext context) {
    final name = UserSession.displayName ?? UserSession.firstName ?? 'account'.tr;

    final needsAttention = state.items
        .where((t) =>
            (t.priority == TaskPriority.urgent ||
                t.priority == TaskPriority.high ||
                t.status == TaskItemStatus.blocked) &&
            t.status != TaskItemStatus.completed &&
            t.status != TaskItemStatus.cancelled)
        .take(_max)
        .toList();

    final inProgress = state.items
        .where((t) => t.status == TaskItemStatus.inProgress)
        .take(_max)
        .toList();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final cutoff = today.add(const Duration(days: 7));
    final dueSoon = state.items
        .where((t) =>
            t.dueDate != null &&
            !t.dueDate!.isBefore(today) &&
            t.dueDate!.isBefore(cutoff) &&
            t.status != TaskItemStatus.completed &&
            t.status != TaskItemStatus.cancelled)
        .take(_max)
        .toList();

    final inProgressCount =
        state.items.where((t) => t.status == TaskItemStatus.inProgress).length;
    final completedCount =
        state.items.where((t) => t.status == TaskItemStatus.completed).length;
    final allEmpty =
        needsAttention.isEmpty && inProgress.isEmpty && dueSoon.isEmpty;

    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      onRefresh: () => context.read<TasksCubit>().refresh(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        children: [
          _GreetingCard(name: name, totalTasks: state.totalCount),
          const SizedBox(height: 20),
          _StatsRow(
            total: state.totalCount,
            inProgressCount: inProgressCount,
            completedCount: completedCount,
            onTap: () => onNavigate(2),
          ),
          const SizedBox(height: 24),
          if (allEmpty)
            _AllCaughtUp(onViewAll: () => onNavigate(2))
          else ...[
            if (needsAttention.isNotEmpty) ...[
              _SectionHeader(
                icon: Icons.bolt_rounded,
                label: 'needs_attention'.tr,
                color: AppColors.kPriorityUrgent,
                onSeeAll: () => onNavigate(2),
              ),
              const SizedBox(height: 10),
              ...needsAttention.map(
                  (t) => _DashboardTaskCard(task: t, onNavigate: onNavigate)),
              const SizedBox(height: 20),
            ],
            if (inProgress.isNotEmpty) ...[
              _SectionHeader(
                icon: Icons.timelapse_rounded,
                label: 'in_progress_tasks'.tr,
                color: AppColors.kStatusInProgress,
                onSeeAll: () => onNavigate(2),
              ),
              const SizedBox(height: 10),
              ...inProgress.map(
                  (t) => _DashboardTaskCard(task: t, onNavigate: onNavigate)),
              const SizedBox(height: 20),
            ],
            if (dueSoon.isNotEmpty) ...[
              _SectionHeader(
                icon: Icons.event_rounded,
                label: 'due_soon'.tr,
                color: AppColors.kWarningColor,
                onSeeAll: () => onNavigate(2),
              ),
              const SizedBox(height: 10),
              ...dueSoon.map(
                  (t) => _DashboardTaskCard(task: t, onNavigate: onNavigate)),
            ],
          ],
        ],
      ),
    );
  }
}

// ─── Greeting card ────────────────────────────────────────────────────────────

class _GreetingCard extends StatelessWidget {
  const _GreetingCard({required this.name, required this.totalTasks});
  final String name;
  final int totalTasks;

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'good_morning'.tr
        : hour < 17
            ? 'good_afternoon'.tr
            : 'good_evening'.tr;
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
          Text(
            greeting,
            style: TextStyle(
              fontFamily: 'Cairo-Bold',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Cairo-Bold',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppColors.radiusFull),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Text(
              totalTasks == 0
                  ? 'tasks_empty_message'.tr
                  : '$totalTasks ${'total_tasks'.tr}',
              style: const TextStyle(
                fontFamily: 'Cairo-Bold',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stats row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.total,
    required this.inProgressCount,
    required this.completedCount,
    required this.onTap,
  });

  final int total;
  final int inProgressCount;
  final int completedCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          icon: Icons.task_alt_rounded,
          label: 'total_tasks'.tr,
          value: total,
          color: Theme.of(context).colorScheme.primary,
          onTap: onTap,
        ),
        const SizedBox(width: 10),
        _StatCard(
          icon: Icons.timelapse_rounded,
          label: 'in_progress_tasks'.tr,
          value: inProgressCount,
          color: AppColors.kStatusInProgress,
          onTap: onTap,
        ),
        const SizedBox(width: 10),
        _StatCard(
          icon: Icons.check_circle_rounded,
          label: 'completed_tasks'.tr,
          value: completedCount,
          color: AppColors.kStatusCompleted,
          onTap: onTap,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int value;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = Theme.of(context).cardTheme.color ?? colorScheme.surface;
    return Expanded(
      child: Material(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppColors.radiusLg),
          highlightColor: Colors.transparent,
          splashColor: color.withValues(alpha: 0.1),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppColors.radiusLg),
              border: Border.all(color: colorScheme.outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppColors.radiusSm),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  '$value',
                  style: TextStyle(
                    fontFamily: 'Cairo-Bold',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Cairo-Bold',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Section header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.color,
    required this.onSeeAll,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppColors.radiusSm),
          ),
          child: Icon(icon, size: 14, color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo-Bold',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Text(
            'see_all'.tr,
            style: TextStyle(
              fontFamily: 'Cairo-Bold',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Dashboard task card ──────────────────────────────────────────────────────

class _DashboardTaskCard extends StatelessWidget {
  const _DashboardTaskCard({required this.task, required this.onNavigate});
  final TaskItemModel task;
  final void Function(int) onNavigate;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = Theme.of(context).cardTheme.color ?? colorScheme.surface;
    final isOverdue = task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        task.status != TaskItemStatus.completed;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppColors.radiusMd),
        border: Border.all(color: colorScheme.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: colorScheme.primary.withValues(alpha: 0.08),
          onTap: () {
            final cubit = context.read<TasksCubit>();
            Get.to(() => TaskDetailsScreen(
                  taskId: task.id,
                  onStatusChanged: (updated) {
                    cubit.updateTask(updated);
                    onNavigate(2);
                  },
                ));
          },
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: task.priority.color,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppColors.radiusMd),
                      bottomLeft: Radius.circular(AppColors.radiusMd),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                task.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Cairo-Bold',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: [
                                  _MiniChip(
                                    label: task.status.label,
                                    color: task.status.color,
                                  ),
                                  if (task.dueDate != null)
                                    _MiniChip(
                                      label: _dueDateLabel(task.dueDate!),
                                      color: isOverdue
                                          ? AppColors.kRedColor
                                          : colorScheme.onSurfaceVariant,
                                      icon: Icons.event_outlined,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(task.status.icon,
                            size: 18, color: task.status.color),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _dueDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    final diff = d.difference(today).inDays;
    if (diff < 0) return 'overdue'.tr;
    if (diff == 0) return 'due_today'.tr;
    if (diff == 1) return 'due_tomorrow'.tr;
    return intl.DateFormat('d/M').format(date);
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.label, required this.color, this.icon});
  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppColors.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: color),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo-Bold',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── All caught up ────────────────────────────────────────────────────────────

class _AllCaughtUp extends StatelessWidget {
  const _AllCaughtUp({required this.onViewAll});
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              size: 44,
              color: AppColors.kStatusCompleted,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'all_caught_up'.tr,
            style: TextStyle(
              fontFamily: 'Cairo-Bold',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'all_caught_up_message'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo-Bold',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: onViewAll,
            icon: const Icon(Icons.list_alt_rounded, size: 16),
            label: Text(
              'see_all'.tr,
              style: const TextStyle(fontFamily: 'Cairo-Bold'),
            ),
          ),
        ],
      ),
    );
  }
}
