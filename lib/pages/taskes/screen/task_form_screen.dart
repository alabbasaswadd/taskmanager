import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wallet/core/components/app_button.dart';
import 'package:wallet/core/components/app_snackbar.dart';
import 'package:wallet/core/components/app_text.dart';
import 'package:wallet/core/components/app_text_form_field.dart';
import 'package:wallet/core/components/shimmer_widgets.dart';
import 'package:wallet/core/enums/domain_enums.dart';
import 'package:wallet/core/networking/api_result.dart';
import 'package:wallet/core/networking/pagination.dart';
import 'package:wallet/pages/projects/api/projects_repository.dart';
import 'package:wallet/pages/projects/model/project_model.dart';
import 'package:wallet/pages/taskes/api/tasks_repository.dart';
import 'package:wallet/pages/taskes/model/task_item_model.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _repo = TasksRepository();
  final _projectsRepo = ProjectsRepository();
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();

  TaskPriority _priority = TaskPriority.medium;
  DateTime? _dueDate;
  String? _projectId;
  List<ProjectModel> _projects = [];
  bool _loading = false;
  bool _projectsLoading = false;
  String? _projectsError;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _loadProjects() async {
    setState(() {
      _projectsLoading = true;
      _projectsError = null;
    });
    final res = await _projectsRepo.getProjects(page: const PageParams(pageSize: 100));
    if (!mounted) return;
    res.when(
      success: (paged) => setState(() {
        _projectsLoading = false;
        _projects = paged.items;
        _projectId ??= paged.items.isNotEmpty ? paged.items.first.id : null;
      }),
      failure: (e) => setState(() {
        _projectsLoading = false;
        _projectsError = e.message ?? 'tasks_loading_error'.tr;
      }),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_projectId == null) {
      AppSnackbar.showError(context, 'select_project'.tr);
      return;
    }
    setState(() => _loading = true);
    final res = await _repo.createTask(
      CreateTaskRequest(
        projectId: _projectId!,
        title: _title.text.trim(),
        description:
            _description.text.trim().isEmpty ? null : _description.text.trim(),
        priority: _priority,
        dueDate: _dueDate,
      ),
    );
    if (!mounted) return;
    setState(() => _loading = false);
    res.when(
      success: (task) {
        AppSnackbar.showSuccess(context, 'task_created'.tr);
        Get.back(result: task);
      },
      failure: (e) => AppSnackbar.showError(context, e.message ?? ''),
    );
  }

  Widget _buildProjectSelector() {
    final cs = Theme.of(context).colorScheme;

    if (_projectsLoading) {
      return const ShimmerWidget.rectangular(height: 56);
    }

    if (_projectsError != null) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: cs.error.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(8),
          color: cs.error.withValues(alpha: 0.06),
        ),
        padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
        child: Row(
          children: [
            Icon(Icons.cloud_off_outlined, size: 18, color: cs.error),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _projectsError!,
                style: TextStyle(fontFamily: 'Cairo-Bold', fontSize: 12, color: cs.error),
              ),
            ),
            TextButton.icon(
              onPressed: _loadProjects,
              icon: Icon(Icons.refresh_rounded, size: 14, color: cs.primary),
              label: Text(
                'retry'.tr,
                style: TextStyle(fontFamily: 'Cairo-Bold', fontSize: 12, color: cs.primary),
              ),
            ),
          ],
        ),
      );
    }

    if (_projects.isEmpty) {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: AppText(
            'no_projects_hint'.tr,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }

    return DropdownButtonFormField<String>(
      initialValue: _projectId,
      decoration: InputDecoration(
        labelText: 'project'.tr,
        prefixIcon: const Icon(Icons.folder_outlined, size: 20),
      ),
      items: _projects
          .map(
            (p) => DropdownMenuItem(
              value: p.id,
              child: Text(
                p.name,
                style: const TextStyle(fontFamily: 'Cairo-Bold', fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: (v) => setState(() => _projectId = v),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('new_task'.tr)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildProjectSelector(),
            const SizedBox(height: 8),
            AppTextFormField(
              label: 'task_title'.tr,
              controller: _title,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'validation_required'.tr : null,
            ),
            AppTextFormField(
              label: 'description'.tr,
              controller: _description,
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<TaskPriority>(
              initialValue: _priority,
              decoration: InputDecoration(labelText: 'priority'.tr),
              items: TaskPriority.values
                  .map((p) => DropdownMenuItem(value: p, child: Text(p.label)))
                  .toList(),
              onChanged: (v) => setState(() => _priority = v ?? TaskPriority.medium),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_outlined),
              title: AppText('due_date'.tr, fontSize: 14),
              subtitle: AppText(
                _dueDate == null
                    ? 'not_set'.tr
                    : '${_dueDate!.year}/${_dueDate!.month}/${_dueDate!.day}',
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              trailing: const Icon(Icons.chevron_left),
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _dueDate ?? now,
                  firstDate: DateTime(now.year - 1),
                  lastDate: DateTime(now.year + 5),
                );
                if (picked != null) setState(() => _dueDate = picked);
              },
            ),
            const SizedBox(height: 24),
            AppButton(text: 'add_task'.tr, isLoading: _loading, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
