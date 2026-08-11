import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

import 'package:wallet/core/components/app_snackbar.dart';
import 'package:wallet/core/components/app_text.dart';
import 'package:wallet/core/components/state_views.dart';
import 'package:wallet/core/constants/colors.dart';
import 'package:wallet/core/enums/domain_enums.dart';
import 'package:wallet/core/networking/api_result.dart';
import 'package:wallet/pages/taskes/api/tasks_repository.dart';
import 'package:wallet/pages/taskes/model/task_item_model.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key, required this.taskId});
  final String taskId;

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

  void _reload() => setState(() => _future = _repo.getTask(widget.taskId));

  Future<void> _changeStatus(TaskItemModel t) async {
    final selected = await showModalBottomSheet<TaskItemStatus>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: TaskItemStatus.values
              .map((s) => ListTile(
                    leading: Icon(s.icon, color: s.color),
                    title: AppText(s.label, fontSize: 14),
                    trailing: t.status == s ? const Icon(Icons.check) : null,
                    onTap: () => Navigator.pop(context, s),
                  ))
              .toList(),
        ),
      ),
    );
    if (selected != null && selected != t.status) {
      final res = await _repo.changeStatus(widget.taskId, selected);
      if (!mounted) return;
      res.when(success: (_) => _reload(), failure: (e) => AppSnackbar.showError(context, e.message ?? ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('task_details'.tr)),
      body: FutureBuilder<ApiResult<TaskItemModel>>(
        future: _future,
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          return snap.data!.when(
            success: (t) => _content(t),
            failure: (e) => ErrorStateView(message: e.message ?? '', onRetry: _reload),
          );
        },
      ),
    );
  }

  Widget _content(TaskItemModel t) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppText(t.title, fontSize: 19, maxLines: 4),
        const SizedBox(height: 12),
        Row(children: [
          StatusChip(label: t.status.label, color: t.status.color, icon: t.status.icon),
          const SizedBox(width: 8),
          StatusChip(label: t.priority.label, color: t.priority.color),
        ]),
        if ((t.description ?? '').isNotEmpty) ...[
          const SizedBox(height: 16),
          AppText(t.description!, fontSize: 14, fontWeight: FontWeight.w400, maxLines: 30),
        ],
        const SizedBox(height: 16),
        if (t.dueDate != null)
          _row(Icons.event_outlined, 'due_date'.tr, intl.DateFormat('yyyy/MM/dd').format(t.dueDate!)),
        if (t.assignees != null && t.assignees!.isNotEmpty)
          _row(Icons.people_alt_outlined, 'assignees'.tr,
              t.assignees!.map((a) => a.displayName ?? '').where((s) => s.isNotEmpty).join('، ')),
        const SizedBox(height: 24),
        Wrap(spacing: 10, children: [
          Material(
            color: AppColors.kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _changeStatus(t),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.timelapse_rounded, size: 18, color: AppColors.kPrimaryColor),
                  const SizedBox(width: 8),
                  AppText('change_status'.tr, fontSize: 13, color: AppColors.kPrimaryColor),
                ]),
              ),
            ),
          ),
        ]),
        // NOTE: task comments & assignee editing endpoints exist in the
        // repository; their UI is pending (see CLAUDE.md → Future Improvements).
      ],
    );
  }

  Widget _row(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Icon(icon, size: 18, color: AppColors.kGreyColor),
          const SizedBox(width: 10),
          AppText(label, fontSize: 13, color: AppColors.kGreyColor, fontWeight: FontWeight.w500),
          const SizedBox(width: 10),
          Expanded(child: AppText(value, fontSize: 13, maxLines: 3, textAlign: TextAlign.end)),
        ]),
      );
}
