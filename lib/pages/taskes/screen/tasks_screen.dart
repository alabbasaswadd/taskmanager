import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

import 'package:wallet/core/components/app_text.dart';
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
        _filters(cubit),
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
                onRefresh: cubit.refresh,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                  itemCount: state.items.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, i) {
                    if (i >= state.items.length) {
                      cubit.loadMore();
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
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

  Widget _filters(TasksCubit cubit) {
    final items = <MapEntry<String, TaskItemStatus?>>[
      MapEntry('filter_all'.tr, null),
      ...TaskItemStatus.values.map((s) => MapEntry(s.label, s)),
    ];
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final e = items[i];
          final selected = _statusFilter == e.value;
          return ChoiceChip(
            label: Text(e.key),
            selected: selected,
            onSelected: (_) {
              setState(() => _statusFilter = e.value);
              cubit.filterByStatus(e.value);
            },
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
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.kGreyColor.withOpacity(0.12)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Get.to(() => TaskDetailsScreen(taskId: task.id)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(task.status.icon, size: 18, color: task.status.color),
                  const SizedBox(width: 8),
                  Expanded(child: AppText(task.title, fontSize: 14, maxLines: 2)),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  StatusChip(label: task.status.label, color: task.status.color),
                  const SizedBox(width: 8),
                  StatusChip(label: task.priority.label, color: task.priority.color),
                  const Spacer(),
                  if (task.dueDate != null) ...[
                    const Icon(Icons.event_outlined, size: 14, color: AppColors.kGreyColor),
                    const SizedBox(width: 4),
                    AppText(intl.DateFormat('MM/dd').format(task.dueDate!),
                        fontSize: 11, color: AppColors.kGreyColor),
                  ],
                  if (task.assigneesTotal > 0) ...[
                    const SizedBox(width: 10),
                    const Icon(Icons.people_alt_outlined, size: 14, color: AppColors.kGreyColor),
                    const SizedBox(width: 4),
                    AppText('${task.assigneesTotal}', fontSize: 11, color: AppColors.kGreyColor),
                  ],
                ]),
              ],
            ),
          ),
        ),
      ),
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
