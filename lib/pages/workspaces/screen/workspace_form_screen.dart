import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wallet/core/components/app_button.dart';
import 'package:wallet/core/components/app_snackbar.dart';
import 'package:wallet/core/components/app_text_form_field.dart';
import 'package:wallet/core/networking/api_result.dart';
import 'package:wallet/pages/workspaces/api/workspaces_repository.dart';
import 'package:wallet/pages/workspaces/model/workspace_model.dart';

/// Create a new workspace. Returns the created [WorkspaceModel] via `Get.back`
/// so the caller (e.g. the project form) can refresh/preselect it.
class WorkspaceFormScreen extends StatefulWidget {
  const WorkspaceFormScreen({super.key});

  @override
  State<WorkspaceFormScreen> createState() => _WorkspaceFormScreenState();
}

class _WorkspaceFormScreenState extends State<WorkspaceFormScreen> {
  final _repo = WorkspacesRepository();
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    final res = await _repo.createWorkspace(
      CreateWorkspaceRequest(
        name: _name.text.trim(),
        description: _description.text.trim().isEmpty ? null : _description.text.trim(),
      ),
    );
    if (!mounted) return;
    setState(() => _loading = false);
    res.when(
      success: (ws) {
        AppSnackbar.showSuccess(context, 'workspace_created'.tr);
        Get.back(result: ws);
      },
      failure: (e) => AppSnackbar.showError(context, e.message ?? ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('new_workspace'.tr)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppTextFormField(
              label: 'workspace_name'.tr,
              controller: _name,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'validation_required'.tr : null,
            ),
            AppTextFormField(
              label: 'description'.tr,
              controller: _description,
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            AppButton(text: 'save'.tr, isLoading: _loading, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
