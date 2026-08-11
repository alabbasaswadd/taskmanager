import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wallet/core/components/shimmer_widgets.dart';
import 'package:wallet/core/components/task_priority_badge.dart';
import 'package:wallet/core/components/task_status_badge.dart';
import 'package:wallet/core/constants/colors.dart';
import 'package:wallet/pages/taskes/bloc/tasks_bloc.dart';
import 'package:wallet/pages/taskes/bloc/tasks_event.dart';
import 'package:wallet/pages/taskes/bloc/tasks_state.dart';
import 'package:wallet/pages/taskes/model/task_enums.dart';
import 'package:wallet/pages/taskes/model/task_model.dart';
import 'package:wallet/pages/taskes/screen/taskes_details_screen.dart';

/// Standalone tasks screen (accessible via route '/tasks').
class TaskesScreen extends StatelessWidget {
  const TaskesScreen({super.key});
  static const id = "/tasks";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TasksBloc()..add(GetAllTasks()),
      child: Scaffold(
        appBar: AppBar(title: Text('my_tasks'.tr)),
        body: BlocBuilder<TasksBloc, TasksState>(
          builder: (context, state) {
            if (state.isLoading) return const TasksListShimmer();

            if (state.isError) {
              return _ErrorState(
                message: state.errorMessage ?? 'tasks_loading_error'.tr,
                onRetry: () => context.read<TasksBloc>().add(GetAllTasks()),
              );
            }

            if (state.tasks.isEmpty) {
              return const _EmptyState();
            }

            return RefreshIndicator(
              color: AppColors.kPrimaryColor,
              onRefresh: () async => context.read<TasksBloc>().add(GetAllTasks()),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: state.tasks.length,
                itemBuilder: (_, i) => TaskCard(task: state.tasks[i]),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Task Card ────────────────────────────────────────────────────────────────

class TaskCard extends StatelessWidget {
  final TaskModel task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => Get.toNamed(
        TaskesDetailsScreen.id,
        arguments: {
          'id': task.id,
          'title': task.title ?? '',
          'description': task.description ?? '',
        },
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.kCardDark : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark ? const Color(0xFF2D3748) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.radio_button_unchecked_rounded,
                    color: AppColors.kPrimaryColor,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title ?? '',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if ((task.description ?? '').isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          task.description!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.kGreyColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.kGreyColor,
                  size: 18.sp,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 6.h,
              children: [
                TaskStatusBadge(status: TaskStatus.notStarted, compact: true),
                TaskPriorityBadge(priority: TaskPriority.medium, compact: true),
                if (task.createdAt != null) _DateBadge(date: task.createdAt!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DateBadge extends StatelessWidget {
  final DateTime date;
  const _DateBadge({required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.kGreyColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today_outlined, size: 10.sp, color: AppColors.kGreyColor),
          SizedBox(width: 4.w),
          Text(
            DateFormat('dd/MM/yyyy').format(date),
            style: TextStyle(fontSize: 10.sp, color: AppColors.kGreyColor),
          ),
        ],
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88.w,
              height: 88.w,
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.task_outlined, size: 44.sp, color: AppColors.kPrimaryColor),
            ),
            SizedBox(height: 20.h),
            Text(
              'no_tasks'.tr,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              'no_tasks_desc'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.kGreyColor,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Error State ──────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88.w,
              height: 88.w,
              decoration: BoxDecoration(
                color: AppColors.kRedColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.cloud_off_rounded, size: 44.sp, color: AppColors.kRedColor),
            ),
            SizedBox(height: 20.h),
            Text(
              'tasks_loading_error'.tr,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: AppColors.kGreyColor),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text('retry'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
