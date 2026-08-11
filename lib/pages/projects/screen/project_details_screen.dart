import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

import 'package:wallet/core/components/app_snackbar.dart';
import 'package:wallet/core/components/app_text.dart';
import 'package:wallet/core/components/state_views.dart';
import 'package:wallet/core/constants/colors.dart';
import 'package:wallet/core/enums/domain_enums.dart';
import 'package:wallet/core/networking/api_result.dart';
import 'package:wallet/pages/projects/api/projects_repository.dart';
import 'package:wallet/pages/projects/model/project_model.dart';
import 'package:wallet/pages/projects/screen/project_form_screen.dart';
import 'package:wallet/pages/taskes/screen/tasks_screen.dart';

class ProjectDetailsScreen extends StatefulWidget {
  const ProjectDetailsScreen({super.key});
  static const String id = "/project-details";

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  final _repo = ProjectsRepository();
  late String _projectId;
  late Future<ApiResult<ProjectModel>> _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _projectId = Get.arguments as String;
    _future = _repo.getProject(_projectId);
  }

  void _reload() => setState(() => _future = _repo.getProject(_projectId));

  Future<void> _changeStatus(ProjectModel p) async {
    final selected = await showModalBottomSheet<ProjectStatus>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ProjectStatus.values
              .map((s) => ListTile(
                    leading: Icon(Icons.circle, size: 14, color: s.color),
                    title: AppText(s.label, fontSize: 14),
                    trailing: p.status == s ? const Icon(Icons.check) : null,
                    onTap: () => Navigator.pop(context, s),
                  ))
              .toList(),
        ),
      ),
    );
    if (selected != null && selected != p.status) {
      final res = await _repo.changeStatus(_projectId, selected);
      if (!mounted) return;
      res.when(
        success: (_) => _reload(),
        failure: (e) => AppSnackbar.showError(context, e.message ?? ''),
      );
    }
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: AppText('confirm_delete_title'.tr, fontSize: 16),
        content: AppText('confirm_delete_project'.tr,
            fontSize: 13, fontWeight: FontWeight.w400, maxLines: 3),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('cancel'.tr)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('delete'.tr)),
        ],
      ),
    );
    if (ok == true) {
      final res = await _repo.deleteProject(_projectId);
      if (!mounted) return;
      res.when(
        success: (_) => Get.back(result: true),
        failure: (e) => AppSnackbar.showError(context, e.message ?? ''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('project_details'.tr)),
      body: FutureBuilder<ApiResult<ProjectModel>>(
        future: _future,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return snap.data!.when(
            success: (p) => _content(p),
            failure: (e) => ErrorStateView(message: e.message ?? '', onRetry: _reload),
          );
        },
      ),
    );
  }

  Widget _content(ProjectModel p) {
    return RefreshIndicator(
      onRefresh: () async => _reload(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppText(p.name, fontSize: 20, maxLines: 3),
          const SizedBox(height: 12),
          Row(children: [
            StatusChip(label: p.status.label, color: p.status.color),
            const SizedBox(width: 8),
            StatusChip(label: p.priority.label, color: p.priority.color),
          ]),
          if ((p.description ?? '').isNotEmpty) ...[
            const SizedBox(height: 16),
            AppText(p.description!, fontSize: 14, fontWeight: FontWeight.w400, maxLines: 20),
          ],
          const SizedBox(height: 16),
          if (p.ownerDisplayName != null)
            _row(Icons.person_outline, 'owner'.tr, p.ownerDisplayName!),
          if (p.targetDate != null)
            _row(Icons.event_outlined, 'target_date'.tr,
                intl.DateFormat('yyyy/MM/dd').format(p.targetDate!)),
          _row(Icons.checklist_rounded, 'tasks'.tr, '${p.taskCount ?? 0}'),
          const SizedBox(height: 24),
          // Quick actions (three-click: Home → Projects → Project → Tasks)
          Wrap(spacing: 10, runSpacing: 10, children: [
            _action(Icons.checklist_rounded, 'view_tasks'.tr,
                () => Get.to(() => ProjectTasksScreen(projectId: p.id, projectName: p.name))),
            _action(Icons.timelapse_rounded, 'change_status'.tr, () => _changeStatus(p)),
            _action(Icons.edit_outlined, 'edit'.tr, () async {
              final changed = await Get.to(() => ProjectFormScreen(existing: p));
              if (changed == true) _reload();
            }),
            _action(Icons.delete_outline_rounded, 'delete'.tr, _delete, danger: true),
          ]),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Icon(icon, size: 18, color: AppColors.kGreyColor),
          const SizedBox(width: 10),
          AppText(label, fontSize: 13, color: AppColors.kGreyColor, fontWeight: FontWeight.w500),
          const Spacer(),
          Flexible(child: AppText(value, fontSize: 13, maxLines: 1)),
        ]),
      );

  Widget _action(IconData icon, String label, VoidCallback onTap, {bool danger = false}) {
    final color = danger ? AppColors.kRedColor : AppColors.kPrimaryColor;
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            AppText(label, fontSize: 13, color: color),
          ]),
        ),
      ),
    );
  }
}
