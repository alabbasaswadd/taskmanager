import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wallet/core/components/app_button.dart';
import 'package:wallet/core/components/app_text.dart';
import 'package:wallet/core/components/shimmer_widgets.dart';
import 'package:wallet/core/networking/api_result.dart';
import 'package:wallet/core/components/app_snackbar.dart';
import 'package:wallet/core/components/app_text_form_field.dart';
import 'package:wallet/core/enums/domain_enums.dart';
import 'package:wallet/pages/projects/api/projects_repository.dart';
import 'package:wallet/pages/projects/model/project_model.dart';
import 'package:wallet/pages/workspaces/api/workspaces_repository.dart';
import 'package:wallet/pages/workspaces/model/workspace_model.dart';
import 'package:wallet/pages/workspaces/screen/workspace_form_screen.dart';

/// Create or edit a project. Pass [existing] to edit; omit to create.
class ProjectFormScreen extends StatefulWidget {
  const ProjectFormScreen({super.key, this.existing});
  final ProjectModel? existing;

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  final _repo = ProjectsRepository();
  final _wsRepo = WorkspacesRepository();
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();

  ProjectPriority _priority = ProjectPriority.medium;
  DateTime? _targetDate;
  String? _workspaceId;
  List<WorkspaceModel> _workspaces = [];
  bool _loading = false;
  bool _wsLoading = false;
  String? _wsError;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _name.text = e.name;
      _description.text = e.description ?? '';
      _priority = e.priority;
      _targetDate = e.targetDate;
      _workspaceId = e.workspaceId;
    } else {
      _loadWorkspaces();
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _loadWorkspaces() async {
    setState(() {
      _wsLoading = true;
      _wsError = null;
    });
    final res = await _wsRepo.getWorkspaces();
    if (!mounted) return;
    res.when(
      success: (paged) => setState(() {
        _wsLoading = false;
        _workspaces = paged.items;
        // _workspaceId is set in the same setState that clears _wsLoading,
        // so when DropdownButtonFormField is first created (after the guard lifts),
        // FormField.initState receives the correct pre-selected value immediately.
        _workspaceId ??= paged.items.isNotEmpty ? paged.items.first.id : null;
      }),
      failure: (e) => setState(() {
        _wsLoading = false;
        _wsError = e.message ?? 'workspace_load_error'.tr;
      }),
    );
  }

  /// Opens the create-workspace screen; on success prepends it to the list and
  /// preselects it so the user can immediately create a project.
  Future<void> _createWorkspace() async {
    final created = await Get.to<WorkspaceModel>(() => const WorkspaceFormScreen());
    if (created == null || !mounted) return;
    setState(() {
      _workspaces = [created, ..._workspaces];
      _workspaceId = created.id;
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_isEdit && _workspaceId == null) {
      AppSnackbar.showError(context, 'select_workspace'.tr);
      return;
    }
    setState(() => _loading = true);
    final res = _isEdit
        ? await _repo.updateProject(
            widget.existing!.id,
            UpdateProjectRequest(
              name: _name.text.trim(),
              description: _description.text.trim().isEmpty ? null : _description.text.trim(),
              priority: _priority,
              targetDate: _targetDate,
            ),
          )
        : await _repo.createProject(
            CreateProjectRequest(
              workspaceId: _workspaceId!,
              name: _name.text.trim(),
              description: _description.text.trim().isEmpty ? null : _description.text.trim(),
              priority: _priority,
              targetDate: _targetDate,
            ),
          );
    if (!mounted) return;
    setState(() => _loading = false);
    res.when(
      success: (_) {
        AppSnackbar.showSuccess(context, 'saved'.tr);
        Get.back(result: true);
      },
      failure: (e) => AppSnackbar.showError(context, e.message ?? ''),
    );
  }

  /// Workspace selector with loading, error, empty, and ready states.
  ///
  /// The DropdownButtonFormField is only instantiated after loading completes so
  /// that FormField.initState receives _workspaceId (the pre-selected value)
  /// directly — bypassing the FormFieldState timing issue where didUpdateWidget
  /// does not reset field.value when initialValue changes on a rebuild.
  Widget _buildWorkspaceSelector() {
    final cs = Theme.of(context).colorScheme;

    if (_wsLoading) {
      return const ShimmerWidget.rectangular(height: 56);
    }

    if (_wsError != null) {
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
                _wsError!,
                style: TextStyle(
                  fontFamily: 'Cairo-Bold',
                  fontSize: 12,
                  color: cs.error,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: _loadWorkspaces,
              icon: Icon(Icons.refresh_rounded, size: 14, color: cs.primary),
              label: Text(
                'retry'.tr,
                style: TextStyle(
                  fontFamily: 'Cairo-Bold',
                  fontSize: 12,
                  color: cs.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // No workspaces yet: guide the user to create one instead of leaving a
    // dead dropdown they cannot select from.
    if (_workspaces.isEmpty) {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppText('no_workspaces_hint'.tr, fontSize: 14, fontWeight: FontWeight.w400),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _createWorkspace,
                icon: const Icon(Icons.add),
                label: Text('create_workspace'.tr),
              ),
            ],
          ),
        ),
      );
    }

    // At this point _workspaceId is already set (same setState as _wsLoading=false),
    // so initialValue: _workspaceId gives FormField the correct initial value immediately.
    return DropdownButtonFormField<String>(
      initialValue: _workspaceId,
      decoration: InputDecoration(
        labelText: 'workspace'.tr,
        prefixIcon: const Icon(Icons.workspaces_outlined, size: 20),
      ),
      items: _workspaces
          .map(
            (w) => DropdownMenuItem(
              value: w.id,
              child: Text(
                w.name,
                style: const TextStyle(fontFamily: 'Cairo-Bold', fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: (v) => setState(() => _workspaceId = v),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'edit_project'.tr : 'new_project'.tr)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (!_isEdit) ...[
              _buildWorkspaceSelector(),
              const SizedBox(height: 8),
            ],
            AppTextFormField(
              label: 'project_name'.tr,
              controller: _name,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'validation_required'.tr : null,
            ),
            AppTextFormField(
              label: 'description'.tr,
              controller: _description,
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ProjectPriority>(
              initialValue: _priority,
              decoration: InputDecoration(labelText: 'priority'.tr),
              items: ProjectPriority.values
                  .map((p) => DropdownMenuItem(value: p, child: Text(p.label)))
                  .toList(),
              onChanged: (v) => setState(() => _priority = v ?? ProjectPriority.medium),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_outlined),
              title: AppText('target_date'.tr, fontSize: 14),
              subtitle: AppText(
                _targetDate == null
                    ? 'not_set'.tr
                    : '${_targetDate!.year}/${_targetDate!.month}/${_targetDate!.day}',
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              trailing: const Icon(Icons.chevron_left),
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _targetDate ?? now,
                  firstDate: DateTime(now.year - 1),
                  lastDate: DateTime(now.year + 5),
                );
                if (picked != null) setState(() => _targetDate = picked);
              },
            ),
            const SizedBox(height: 24),
            AppButton(text: 'save'.tr, isLoading: _loading, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
