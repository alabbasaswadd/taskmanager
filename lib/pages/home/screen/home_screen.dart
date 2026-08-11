import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:wallet/core/components/app_drawer.dart';
import 'package:wallet/core/components/app_snackbar.dart';
import 'package:wallet/core/components/shimmer_widgets.dart';
import 'package:wallet/core/components/task_priority_badge.dart';
import 'package:wallet/core/components/task_status_badge.dart';
import 'package:wallet/core/constants/colors.dart';
import 'package:wallet/core/constants/functions.dart';
import 'package:wallet/pages/taskes/bloc/tasks_bloc.dart';
import 'package:wallet/pages/taskes/bloc/tasks_event.dart';
import 'package:wallet/pages/taskes/bloc/tasks_state.dart';
import 'package:wallet/pages/taskes/model/task_enums.dart';
import 'package:wallet/pages/taskes/model/task_model.dart';
import 'package:wallet/pages/taskes/screen/taskes_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String id = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late final TasksBloc _tasksBloc;

  @override
  void initState() {
    super.initState();
    _tasksBloc = TasksBloc()..add(GetAllTasks());
  }

  @override
  void dispose() {
    _tasksBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _tasksBloc,
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: _buildAppBar(context),
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            _DashboardTab(),
            _TasksTab(),
            _NotificationsTab(),
            _AccountTab(),
          ],
        ),
        floatingActionButton: _currentIndex < 2
            ? FloatingActionButton(
                onPressed: () => _showNewTaskSheet(context),
                child: const Icon(Icons.add_rounded),
              )
            : null,
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final titles = ['home'.tr, 'my_tasks'.tr, 'notifications'.tr, 'account'.tr];
    return AppBar(
      title: Text(titles[_currentIndex]),
      actions: [
        if (_currentIndex == 0)
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => setState(() => _currentIndex = 2),
            tooltip: 'notifications'.tr,
          ),
        if (_currentIndex == 1)
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => _tasksBloc.add(GetAllTasks()),
            tooltip: 'retry'.tr,
          ),
      ],
    );
  }

  BottomNavigationBar _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (i) => setState(() => _currentIndex = i),
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.dashboard_outlined),
          activeIcon: const Icon(Icons.dashboard_rounded),
          label: 'home'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.task_outlined),
          activeIcon: const Icon(Icons.task_rounded),
          label: 'tasks'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.notifications_outlined),
          activeIcon: const Icon(Icons.notifications_rounded),
          label: 'notifications'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_outline_rounded),
          activeIcon: const Icon(Icons.person_rounded),
          label: 'account'.tr,
        ),
      ],
    );
  }

  void _showNewTaskSheet(BuildContext context) {
    AppSnackbar.showInfo(context, 'feature_requires_backend'.tr);
  }
}

// ─── Dashboard Tab ────────────────────────────────────────────────────────────

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'good_morning'.tr;
    if (hour < 18) return 'good_afternoon'.tr;
    return 'good_evening'.tr;
  }

  String _todayDate() {
    return intl.DateFormat('EEEE، d MMMM y', 'ar').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final name = UserSession.firstName ?? UserSession.fullName;

    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        if (state.isLoading) return const DashboardShimmer();

        final tasks = state.tasks;
        final total = tasks.length;

        return RefreshIndicator(
          color: AppColors.kPrimaryColor,
          onRefresh: () async => context.read<TasksBloc>().add(GetAllTasks()),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Greeting ───────────────────────────────────────────
                _GreetingCard(
                  greeting: _greeting(),
                  name: name,
                  dateStr: _todayDate(),
                  isDark: isDark,
                ),
                SizedBox(height: 20.h),

                // ─── Stats Row ──────────────────────────────────────────
                if (state.isError)
                  _ErrorBanner(
                    message: state.errorMessage ?? 'tasks_loading_error'.tr,
                    onRetry: () => context.read<TasksBloc>().add(GetAllTasks()),
                  )
                else ...[
                  Text(
                    'overview'.tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _StatsRow(totalTasks: total),
                  SizedBox(height: 20.h),

                  // ─── Progress ─────────────────────────────────────────
                  _ProgressCard(total: total),
                  SizedBox(height: 20.h),

                  // ─── Recent Tasks ─────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'recent_tasks'.tr,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(onPressed: () {}, child: Text('see_all'.tr)),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  if (tasks.isEmpty)
                    _EmptyDashboard()
                  else
                    ...tasks
                        .take(5)
                        .map((task) => _DashboardTaskItem(task: task)),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GreetingCard extends StatelessWidget {
  final String greeting;
  final String? name;
  final String dateStr;
  final bool isDark;

  const _GreetingCard({
    required this.greeting,
    required this.name,
    required this.dateStr,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.kPrimaryColor, Color(0xFFF06292)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      name ?? greeting,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.task_alt_rounded,
                  color: Colors.white,
                  size: 28.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              dateStr,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int totalTasks;
  const _StatsRow({required this.totalTasks});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'total_tasks'.tr,
            value: totalTasks.toString(),
            color: AppColors.kPrimaryColor,
            icon: Icons.list_alt_rounded,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _StatCard(
            label: 'in_progress_tasks'.tr,
            value: '—',
            color: AppColors.kStatusInProgress,
            icon: Icons.timelapse_rounded,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _StatCard(
            label: 'overdue_tasks'.tr,
            value: '—',
            color: AppColors.kStatusOverdue,
            icon: Icons.warning_amber_rounded,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(14.w),
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
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: color, size: 18.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(fontSize: 10.sp, color: AppColors.kGreyColor),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final int total;
  const _ProgressCard({required this.total});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const completed = 0;
    final percent = total > 0 ? (completed / total) : 0.0;

    return Container(
      padding: EdgeInsets.all(18.w),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'completion_rate'.tr,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                '${(percent * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kPrimaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8.h,
              backgroundColor: AppColors.kPrimaryColor.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation(AppColors.kPrimaryColor),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            '$completed ${'tasks_completed'.tr}  ·  ${total - completed} ${'tasks_remaining'.tr}',
            style: TextStyle(fontSize: 12.sp, color: AppColors.kGreyColor),
          ),
        ],
      ),
    );
  }
}

class _DashboardTaskItem extends StatelessWidget {
  final TaskModel task;
  const _DashboardTaskItem({required this.task});

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
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.kCardDark : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isDark ? const Color(0xFF2D3748) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
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
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if ((task.description ?? '').isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    Text(
                      task.description!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.kGreyColor,
                      ),
                      maxLines: 1,
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
      ),
    );
  }
}

class _EmptyDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.task_outlined,
              size: 36.sp,
              color: AppColors.kPrimaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'great_work'.tr,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBanner({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.kStatusOverdue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.kStatusOverdue.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: AppColors.kStatusOverdue,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.kStatusOverdue,
              ),
            ),
          ),
          TextButton(onPressed: onRetry, child: Text('retry'.tr)),
        ],
      ),
    );
  }
}

// ─── Tasks Tab ────────────────────────────────────────────────────────────────

class _TasksTab extends StatefulWidget {
  const _TasksTab();

  @override
  State<_TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<_TasksTab> {
  int _filterIndex = 0;

  final List<String> _filterKeys = [
    'filter_all',
    'filter_in_progress',
    'filter_completed',
    'filter_overdue',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        if (state.isLoading) return const TasksListShimmer();

        if (state.isError) {
          return _TasksErrorState(
            message: state.errorMessage ?? 'tasks_loading_error'.tr,
            onRetry: () => context.read<TasksBloc>().add(GetAllTasks()),
          );
        }

        if (state.tasks.isEmpty && !state.isLoading) {
          return const _TasksEmptyState();
        }

        return Column(
          children: [
            // ─── Filter chips ──────────────────────────────────────────
            _FilterChipsRow(
              filters: _filterKeys,
              selectedIndex: _filterIndex,
              onSelected: (i) => setState(() => _filterIndex = i),
            ),
            // ─── Task list ─────────────────────────────────────────────
            Expanded(
              child: RefreshIndicator(
                color: AppColors.kPrimaryColor,
                onRefresh: () async =>
                    context.read<TasksBloc>().add(GetAllTasks()),
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 100.h),
                  itemCount: state.tasks.length,
                  itemBuilder: (_, i) => _TaskListCard(task: state.tasks[i]),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FilterChipsRow extends StatelessWidget {
  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _FilterChipsRow({
    required this.filters,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.kBackgroundDark
          : AppColors.kBackgroundLight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          final selected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onSelected(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.kPrimaryColor
                    : AppColors.kPrimaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                filters[i].tr,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.kPrimaryColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TaskListCard extends StatelessWidget {
  final TaskModel task;
  const _TaskListCard({required this.task});

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
            // Title row
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
            // Badges row
            Wrap(
              spacing: 8.w,
              runSpacing: 6.h,
              children: [
                TaskStatusBadge(status: TaskStatus.notStarted, compact: true),
                TaskPriorityBadge(priority: TaskPriority.medium, compact: true),
                if (task.createdAt != null) _DateChip(date: task.createdAt!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final DateTime date;
  const _DateChip({required this.date});

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
          Icon(
            Icons.calendar_today_outlined,
            size: 10.sp,
            color: AppColors.kGreyColor,
          ),
          SizedBox(width: 4.w),
          Text(
            intl.DateFormat('dd/MM/yyyy').format(date),
            style: TextStyle(fontSize: 10.sp, color: AppColors.kGreyColor),
          ),
        ],
      ),
    );
  }
}

class _TasksEmptyState extends StatelessWidget {
  const _TasksEmptyState();

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
              child: Icon(
                Icons.task_outlined,
                size: 44.sp,
                color: AppColors.kPrimaryColor,
              ),
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

class _TasksErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _TasksErrorState({required this.message, required this.onRetry});

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
              child: Icon(
                Icons.cloud_off_rounded,
                size: 44.sp,
                color: AppColors.kRedColor,
              ),
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

// ─── Notifications Tab ────────────────────────────────────────────────────────

class _NotificationsTab extends StatelessWidget {
  const _NotificationsTab();

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
                color: AppColors.kPrimaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_outlined,
                size: 44.sp,
                color: AppColors.kPrimaryColor,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'no_notifications'.tr,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              'no_notifications_desc'.tr,
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

// ─── Account Tab ─────────────────────────────────────────────────────────────

class _AccountTab extends StatelessWidget {
  const _AccountTab();

  @override
  Widget build(BuildContext context) {
    final name = UserSession.fullName ?? 'account'.tr;
    final email = UserSession.email ?? '';

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          // Avatar
          Container(
            width: 84.w,
            height: 84.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.kPrimaryColor, AppColors.kSecondColor],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_rounded, size: 44.sp, color: Colors.white),
          ),
          SizedBox(height: 14.h),
          Text(
            name,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          if (email.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              email,
              style: TextStyle(fontSize: 13.sp, color: AppColors.kGreyColor),
            ),
          ],
          SizedBox(height: 28.h),
          // Menu
          _AccountSection(
            items: [
              _AccountMenuItem(
                icon: Icons.person_outline_rounded,
                label: 'my_profile'.tr,
                onTap: () {},
              ),
              _AccountMenuItem(
                icon: Icons.lock_outline_rounded,
                label: 'change_password'.tr,
                onTap: () {},
              ),
              _AccountMenuItem(
                icon: Icons.notifications_outlined,
                label: 'notifications'.tr,
                onTap: () {},
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _AccountSection(
            items: [
              _AccountMenuItem(
                icon: Icons.language_rounded,
                label: 'language'.tr,
                trailing: Text(
                  'العربية',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.kGreyColor,
                  ),
                ),
                onTap: () {},
              ),
              _AccountMenuItem(
                icon: Icons.dark_mode_outlined,
                label: 'dark_mode'.tr,
                onTap: () {},
              ),
              _AccountMenuItem(
                icon: Icons.info_outline_rounded,
                label: 'about_app'.tr,
                onTap: () {},
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _AccountSection(
            items: [
              _AccountMenuItem(
                icon: Icons.logout_rounded,
                label: 'log_out'.tr,
                iconColor: AppColors.kRedColor,
                labelColor: AppColors.kRedColor,
                onTap: () {
                  UserSession.clear();
                  Get.offAllNamed('/sign-in');
                },
              ),
            ],
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

class _AccountSection extends StatelessWidget {
  final List<_AccountMenuItem> items;
  const _AccountSection({required this.items});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.kCardDark : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? const Color(0xFF2D3748) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              item,
              if (i < items.length - 1)
                Divider(
                  height: 1,
                  indent: 56.w,
                  endIndent: 16.w,
                  color: isDark
                      ? const Color(0xFF2D3748)
                      : const Color(0xFFE2E8F0),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _AccountMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;
  final Widget? trailing;

  const _AccountMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 38.w,
        height: 38.w,
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.kPrimaryColor).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.kPrimaryColor,
          size: 20.sp,
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: labelColor,
        ),
      ),
      trailing:
          trailing ??
          Icon(
            Icons.chevron_left_rounded,
            color: AppColors.kGreyColor,
            size: 20.sp,
          ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
    );
  }
}
