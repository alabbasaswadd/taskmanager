import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

import 'package:wallet/core/components/app_text.dart';
import 'package:wallet/core/components/shimmer_widgets.dart';
import 'package:wallet/core/components/state_views.dart';
import 'package:wallet/core/constants/colors.dart';
import 'package:wallet/core/enums/domain_enums.dart';
import 'package:wallet/core/state/paged_list_state.dart';
import 'package:wallet/pages/projects/cubit/projects_cubit.dart';
import 'package:wallet/pages/projects/model/project_model.dart';
import 'package:wallet/pages/projects/screen/project_details_screen.dart';

/// Projects tab body — self-contained (provides its own cubit).
class ProjectsBody extends StatelessWidget {
  const ProjectsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProjectsCubit()..load(),
      child: const _ProjectsList(),
    );
  }
}

class _ProjectsList extends StatelessWidget {
  const _ProjectsList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsCubit, PagedListState<ProjectModel>>(
      builder: (context, state) {
        final cubit = context.read<ProjectsCubit>();
        if (state.isInitialLoading) return const TasksListShimmer();
        if (state.status == ViewStatus.error && state.items.isEmpty) {
          return ErrorStateView(message: state.error ?? '', onRetry: cubit.refresh);
        }
        if (state.status == ViewStatus.empty) {
          return EmptyStateView(
            icon: Icons.folder_open_rounded,
            title: 'projects_empty_title'.tr,
            message: 'projects_empty_message'.tr,
          );
        }
        return RefreshIndicator(
          onRefresh: cubit.refresh,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
            itemCount: state.items.length + (state.hasMore ? 1 : 0),
            itemBuilder: (context, i) {
              if (i >= state.items.length) {
                cubit.loadMore();
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              }
              return ProjectCard(project: state.items[i]);
            },
          ),
        );
      },
    );
  }
}

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project});
  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.kGreyColor.withOpacity(0.12)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.toNamed(ProjectDetailsScreen.id, arguments: project.id),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: AppText(project.name, fontSize: 15, maxLines: 1)),
                    StatusChip(label: project.priority.label, color: project.priority.color),
                  ],
                ),
                if ((project.description ?? '').isNotEmpty) ...[
                  const SizedBox(height: 6),
                  AppText(project.description!,
                      fontSize: 12,
                      maxLines: 2,
                      fontWeight: FontWeight.w400,
                      color: AppColors.kGreyColor),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    StatusChip(label: project.status.label, color: project.status.color),
                    const Spacer(),
                    const Icon(Icons.checklist_rounded, size: 15, color: AppColors.kGreyColor),
                    const SizedBox(width: 4),
                    AppText('${project.taskCount ?? 0}',
                        fontSize: 12, color: AppColors.kGreyColor),
                    if (project.targetDate != null) ...[
                      const SizedBox(width: 12),
                      const Icon(Icons.event_outlined, size: 15, color: AppColors.kGreyColor),
                      const SizedBox(width: 4),
                      AppText(intl.DateFormat('yyyy/MM/dd').format(project.targetDate!),
                          fontSize: 12, color: AppColors.kGreyColor),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
