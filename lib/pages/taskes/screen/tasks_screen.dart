import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

import 'package:wallet/core/components/shimmer_widgets.dart';
import 'package:wallet/core/components/state_views.dart';
import 'package:wallet/core/constants/colors.dart';
import 'package:wallet/core/enums/domain_enums.dart';
import 'package:wallet/core/state/paged_list_state.dart';
import 'package:wallet/pages/taskes/cubit/tasks_cubit.dart';
import 'package:wallet/pages/taskes/model/task_item_model.dart';
import 'package:wallet/pages/taskes/screen/task_details_screen.dart';

/// Tasks tab body (all tasks across the user's workspaces).
class TasksBody extends StatelessWidget {
  const TasksBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TasksCubit()..load(),
      child: const _TasksList(),
    );
  }
}

class _TasksList extends StatefulWidget {
  const _TasksList();
  @override
  State<_TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<_TasksList> {
  TaskItemStatus? _statusFilter;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TasksCubit>();
    return Column(
      children: [
        _filters(context, cubit),
        Expanded(
          child: BlocBuilder<TasksCubit, PagedListState<TaskItemModel>>(
            builder: (context, state) {
              if (state.isInitialLoading) return const TasksListShimmer();
              if (state.status == ViewStatus.error && state.items.isEmpty) {
                return ErrorStateView(message: state.error ?? '', onRetry: cubit.refresh);
              }
              if (state.status == ViewStatus.empty) {
                return EmptyStateView(
                  icon: Icons.check_circle_outline_rounded,
                  title: 'tasks_empty_title'.tr,
                  message: 'tasks_empty_message'.tr,
                );
              }
              return RefreshIndicator(
                color: Theme.of(context).colorScheme.primary,
                onRefresh: cubit.refresh,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                  itemCount: state.items.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, i) {
                    if (i >= state.items.length) {
                      cubit.loadMore();
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      );
                    }
                    return TaskCard(task: state.items[i]);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _filters(BuildContext context, TasksCubit cubit) {
    final colorScheme = Theme.of(context).colorScheme;
    final items = <MapEntry<String, TaskItemStatus?>>[
      MapEntry('filter_all'.tr, null),
      ...TaskItemStatus.values.map((s) => MapEntry(s.label, s)),
    ];
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        border: Border(bottom: BorderSide(color: colorScheme.outline, width: 1)),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final e = items[i];
          final selected = _statusFilter == e.value;
          return GestureDetector(
            onTap: () {
              setState(() => _statusFilter = e.value);
              cubit.filterByStatus(e.value);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: selected
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppColors.radiusFull),
                border: Border.all(
                  color: selected ? colorScheme.primary : colorScheme.outline,
                ),
              ),
              child: Text(
                e.key,
                style: TextStyle(
                  fontFamily: 'Cairo-Bold',
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? Colors.white : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});
  final TaskItemModel task;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = Theme.of(context).cardTheme.color ?? colorScheme.surface;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
          onTap: () => Get.to(() => TaskDetailsScreen(taskId: task.id)),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Priority accent bar
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
                    padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                task.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Cairo-Bold',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurface,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(task.status.icon, size: 17, color: task.status.color),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            StatusChip(label: task.status.label, color: task.status.color),
                            const SizedBox(width: 6),
                            StatusChip(label: task.priority.label, color: task.priority.color),
                            const Spacer(),
                            if (task.dueDate != null) _dueChip(context, task.dueDate!),
                            if (task.assigneesTotal > 0) _assigneeChip(context, task.assigneesTotal),
                          ],
                        ),
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

  Widget _dueChip(BuildContext context, DateTime date) {
    final overdue = date.isBefore(DateTime.now());
    final color = overdue
        ? AppColors.kRedColor
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.event_outlined, size: 13, color: color),
        const SizedBox(width: 3),
        Text(
          intl.DateFormat('d/M').format(date),
          style: TextStyle(
            fontFamily: 'Cairo-Bold',
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _assigneeChip(BuildContext context, int count) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 8),
        Icon(Icons.people_alt_outlined, size: 13, color: color),
        const SizedBox(width: 3),
        Text(
          '$count',
          style: TextStyle(
            fontFamily: 'Cairo-Bold',
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Tasks scoped to one project (reached from project details).
class ProjectTasksScreen extends StatelessWidget {
  const ProjectTasksScreen({super.key, required this.projectId, required this.projectName});
  final String projectId;
  final String projectName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(projectName)),
      body: BlocProvider(
        create: (_) => TasksCubit()..load(projectId: projectId),
        child: const _TasksList(),
      ),
    );
  }
}
