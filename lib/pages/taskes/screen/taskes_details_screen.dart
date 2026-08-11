import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wallet/core/components/app_button.dart';
import 'package:wallet/core/components/app_snackbar.dart';
import 'package:wallet/core/components/task_priority_badge.dart';
import 'package:wallet/core/components/task_status_badge.dart';
import 'package:wallet/core/constants/colors.dart';
import 'package:wallet/pages/taskes/model/task_enums.dart';

class TaskesDetailsScreen extends StatefulWidget {
  const TaskesDetailsScreen({super.key});
  static String id = "/task-details";

  @override
  State<TaskesDetailsScreen> createState() => _TaskesDetailsScreenState();
}

class _TaskesDetailsScreenState extends State<TaskesDetailsScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final task = Get.arguments as Map<String, dynamic>?;
    _titleController = TextEditingController(text: task?['title'] ?? '');
    _descriptionController = TextEditingController(text: task?['description'] ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_titleController.text.trim().isEmpty) {
      AppSnackbar.showError(context, 'field_required'.tr);
      return;
    }
    setState(() => _isEditing = false);
    AppSnackbar.showSuccess(context, 'task_saved'.tr);
    Get.back(result: {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('task_details'.tr),
        actions: [
          if (_isEditing)
            TextButton(
              onPressed: _saveTask,
              child: Text(
                'save'.tr,
                style: const TextStyle(
                  color: AppColors.kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => setState(() => _isEditing = true),
              tooltip: 'edit'.tr,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Title Card ──────────────────────────────────────────────
            _SectionCard(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('task_title'.tr),
                  SizedBox(height: 8.h),
                  _isEditing
                      ? TextField(
                          controller: _titleController,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: 'task_title_hint'.tr,
                          ),
                        )
                      : Text(
                          _titleController.text.isNotEmpty
                              ? _titleController.text
                              : 'no_description'.tr,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // ─── Description Card ────────────────────────────────────────
            _SectionCard(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('task_description'.tr),
                  SizedBox(height: 8.h),
                  _isEditing
                      ? TextField(
                          controller: _descriptionController,
                          textDirection: TextDirection.rtl,
                          maxLines: 5,
                          style: TextStyle(fontSize: 14.sp),
                          decoration: InputDecoration(
                            hintText: 'task_description_hint'.tr,
                            alignLabelWithHint: true,
                          ),
                        )
                      : Text(
                          _descriptionController.text.isNotEmpty
                              ? _descriptionController.text
                              : 'no_description'.tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: _descriptionController.text.isEmpty
                                ? AppColors.kGreyColor
                                : null,
                            height: 1.6,
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // ─── Status & Priority ───────────────────────────────────────
            _SectionCard(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldRow(
                    label: 'status'.tr,
                    value: TaskStatusBadge(status: TaskStatus.notStarted),
                  ),
                  Divider(height: 20.h, color: isDark ? const Color(0xFF2D3748) : const Color(0xFFE2E8F0)),
                  _FieldRow(
                    label: 'priority'.tr,
                    value: TaskPriorityBadge(priority: TaskPriority.medium),
                  ),
                  Divider(height: 20.h, color: isDark ? const Color(0xFF2D3748) : const Color(0xFFE2E8F0)),
                  _FieldRow(
                    label: 'due_date'.tr,
                    value: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 14.sp, color: AppColors.kGreyColor),
                        SizedBox(width: 6.w),
                        Text(
                          '—',
                          style: TextStyle(fontSize: 13.sp, color: AppColors.kGreyColor),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 20.h, color: isDark ? const Color(0xFF2D3748) : const Color(0xFFE2E8F0)),
                  _FieldRow(
                    label: 'project'.tr,
                    value: Text(
                      '—',
                      style: TextStyle(fontSize: 13.sp, color: AppColors.kGreyColor),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // ─── Delete Button (future backend) ──────────────────────────
            AppButton(
              text: 'delete'.tr,
              onPressed: () => AppSnackbar.showInfo(context, 'feature_requires_backend'.tr),
              color: AppColors.kRedColor,
              padding: EdgeInsets.zero,
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

// ─── Supporting Widgets ───────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final bool isDark;
  final Widget child;
  const _SectionCard({required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.kCardDark : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? const Color(0xFF2D3748) : const Color(0xFFE2E8F0),
        ),
      ),
      child: child,
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.kGreyColor,
        letterSpacing: 0.3,
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  final String label;
  final Widget value;
  const _FieldRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.kGreyColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        value,
      ],
    );
  }
}
