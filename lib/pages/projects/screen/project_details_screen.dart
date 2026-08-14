import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

import 'package:wallet/core/components/app_snackbar.dart';
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

  void _reload() => setState(() { _future = _repo.getProject(_projectId); });

  Future<void> _changeStatus(ProjectModel p) async {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = await showModalBottomSheet<ProjectStatus>(
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
            ...ProjectStatus.values.map((s) => ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: s.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppColors.radiusSm),
                    ),
                    child: Icon(Icons.circle, size: 12, color: s.color),
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
                  trailing: p.status == s
                      ? Icon(Icons.check_rounded, color: colorScheme.primary)
                      : null,
                  onTap: () => Navigator.pop(context, s),
                )),
            const SizedBox(height: 8),
          ],
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
    final colorScheme = Theme.of(context).colorScheme;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'confirm_delete_title'.tr,
          style: TextStyle(
            fontFamily: 'Cairo-Bold',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        content: Text(
          'confirm_delete_project'.tr,
          style: TextStyle(
            fontFamily: 'Cairo-Bold',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.kRedColor),
            child: Text('delete'.tr),
          ),
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
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
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
      color: Theme.of(context).colorScheme.primary,
      onRefresh: () async => _reload(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _headerCard(p),
          const SizedBox(height: 16),
          if ((p.description ?? '').isNotEmpty) ...[
            _descriptionCard(p.description!),
            const SizedBox(height: 12),
          ],
          _infoCard(p),
          const SizedBox(height: 24),
          _actionsSection(p),
        ],
      ),
    );
  }

  Widget _headerCard(ProjectModel p) {
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
            p.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Cairo-Bold',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _headerChip(p.status.label),
              const SizedBox(width: 8),
              _headerChip(p.priority.label),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppColors.radiusSm),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Cairo-Bold',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
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
            maxLines: 20,
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

  Widget _infoCard(ProjectModel p) {
    final colorScheme = Theme.of(context).colorScheme;
    final rows = <Widget>[];

    if (p.ownerDisplayName != null) {
      rows.add(_infoRow(Icons.person_outline, 'owner'.tr, p.ownerDisplayName!, colorScheme));
    }
    if (p.targetDate != null) {
      if (rows.isNotEmpty) rows.add(Divider(height: 16, color: colorScheme.outline));
      rows.add(_infoRow(
        Icons.event_outlined,
        'target_date'.tr,
        intl.DateFormat('d/M/yyyy').format(p.targetDate!),
        colorScheme,
      ));
    }
    if (rows.isNotEmpty) rows.add(Divider(height: 16, color: colorScheme.outline));
    rows.add(_infoRow(Icons.checklist_rounded, 'tasks'.tr, '${p.taskCount ?? 0}', colorScheme));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(AppColors.radiusMd),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(children: rows),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
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
          const Spacer(),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: 'Cairo-Bold',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionsSection(ProjectModel p) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.checklist_rounded, size: 18),
            label: Text('view_tasks'.tr),
            onPressed: () =>
                Get.to(() => ProjectTasksScreen(projectId: p.id, projectName: p.name)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                label: Text('change_status'.tr),
                onPressed: () => _changeStatus(p),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: Text('edit'.tr),
                onPressed: () async {
                  final changed = await Get.to(() => ProjectFormScreen(existing: p));
                  if (changed == true) _reload();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.delete_outline_rounded, size: 18),
            label: Text('delete'.tr),
            onPressed: _delete,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.kRedColor,
              side: BorderSide(color: AppColors.kRedColor.withValues(alpha: 0.4)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
