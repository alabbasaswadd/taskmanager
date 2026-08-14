import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

import 'package:wallet/core/components/app_snackbar.dart';
import 'package:wallet/core/components/state_views.dart';
import 'package:wallet/core/constants/colors.dart';
import 'package:wallet/core/enums/domain_enums.dart';
import 'package:wallet/core/networking/api_result.dart';
import 'package:wallet/pages/taskes/api/tasks_repository.dart';
import 'package:wallet/pages/taskes/model/task_item_model.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key, required this.taskId, this.onStatusChanged});
  final String taskId;
  // Called with the updated task after a successful status change.
  final void Function(TaskItemModel updated)? onStatusChanged;

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final _repo = TasksRepository();
  late Future<ApiResult<TaskItemModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.getTask(widget.taskId);
  }

  Future<void> _changeStatus(TaskItemModel t) async {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = await showModalBottomSheet<TaskItemStatus>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppColors.radiusXl)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outline,
                borderRadius: BorderRadius.circular(AppColors.radiusFull),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'change_status'.tr,
                style: TextStyle(
                  fontFamily: 'Cairo-Bold',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            Divider(height: 1, color: colorScheme.outline),
            ...TaskItemStatus.values.map((s) => ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: s.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppColors.radiusSm),
                    ),
                    child: Icon(s.icon, size: 18, color: s.color),
                  ),
                  title: Text(
                    s.label,
                    style: TextStyle(
                      fontFamily: 'Cairo-Bold',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  trailing: t.status == s
                      ? Icon(Icons.check_rounded, color: colorScheme.primary)
                      : null,
                  onTap: () => Navigator.pop(context, s),
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (selected != null && selected != t.status) {
      final res = await _repo.changeStatus(widget.taskId, selected);
      if (!mounted) return;
      res.when(
        success: (updated) {
          widget.onStatusChanged?.call(updated);
          if (mounted) AppSnackbar.showSuccess(context, 'task_status_updated'.tr);
          Get.back(result: true);
        },
        failure: (e) => AppSnackbar.showError(context, e.message ?? ''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('task_details'.tr)),
      body: FutureBuilder<ApiResult<TaskItemModel>>(
        future: _future,
        builder: (context, snap) {
          if (!snap.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }
          return snap.data!.when(
            success: (t) => _content(t),
            failure: (e) => ErrorStateView(
                  message: e.message ?? '',
                  onRetry: () => setState(() {
                    _future = _repo.getTask(widget.taskId);
                  }),
                ),
          );
        },
      ),
    );
  }

  Widget _content(TaskItemModel t) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _headerCard(t),
        const SizedBox(height: 16),
        if ((t.description ?? '').isNotEmpty)
          _descriptionCard(t.description!),
        const SizedBox(height: 12),
        _infoCard(t),
        const SizedBox(height: 24),
        _changeStatusButton(t),
      ],
    );
  }

  Widget _headerCard(TaskItemModel t) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = colorScheme.primary;
    final gradientEnd = isDark ? AppColors.kPrimaryDark : const Color(0xFFA21CAF);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Cairo-Bold',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _headerChip(t.status.label, icon: t.status.icon),
              const SizedBox(width: 8),
              _headerChip(t.priority.label),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerChip(String label, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppColors.radiusSm),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: Colors.white),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Cairo-Bold',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _descriptionCard(String desc) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(AppColors.radiusMd),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'description'.tr,
            style: TextStyle(
              fontFamily: 'Cairo-Bold',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            maxLines: 30,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Cairo-Bold',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurface,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(TaskItemModel t) {
    final hasDueDate = t.dueDate != null;
    final hasAssignees = t.assignees != null && t.assignees!.isNotEmpty;

    if (!hasDueDate && !hasAssignees) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final rows = <Widget>[];

    if (hasDueDate) {
      rows.add(_infoRow(
        Icons.event_outlined,
        'due_date'.tr,
        intl.DateFormat('yyyy/MM/dd').format(t.dueDate!),
        colorScheme,
      ));
    }
    if (hasDueDate && hasAssignees) {
      rows.add(Divider(height: 16, color: colorScheme.outline));
    }
    if (hasAssignees) {
      final names =
          t.assignees!.map((a) => a.displayName ?? '').where((s) => s.isNotEmpty).join('، ');
      rows.add(_infoRow(Icons.people_alt_outlined, 'assignees'.tr, names, colorScheme));
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(AppColors.radiusMd),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, ColorScheme colorScheme) {
    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo-Bold',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontFamily: 'Cairo-Bold',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _changeStatusButton(TaskItemModel t) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.swap_horiz_rounded, size: 18),
        label: Text('change_status'.tr),
        onPressed: () => _changeStatus(t),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
