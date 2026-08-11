import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

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
          color: Theme.of(context).colorScheme.primary,
          onRefresh: cubit.refresh,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
            itemCount: state.items.length + (state.hasMore ? 1 : 0),
            itemBuilder: (context, i) {
              if (i >= state.items.length) {
                cubit.loadMore();
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
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
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = Theme.of(context).cardTheme.color ?? colorScheme.surface;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
        border: Border.all(color: colorScheme.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppColors.radiusLg),
          highlightColor: Colors.transparent,
          splashColor: colorScheme.primary.withValues(alpha: 0.08),
          onTap: () => Get.toNamed(ProjectDetailsScreen.id, arguments: project.id),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Status accent bar
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: project.status.color,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppColors.radiusLg),
                      bottomLeft: Radius.circular(AppColors.radiusLg),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                project.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Cairo-Bold',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurface,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            StatusChip(
                              label: project.priority.label,
                              color: project.priority.color,
                            ),
                          ],
                        ),
                        if ((project.description ?? '').isNotEmpty) ...[
                          const SizedBox(height: 5),
                          Text(
                            project.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Cairo-Bold',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: colorScheme.onSurfaceVariant,
                              height: 1.5,
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            StatusChip(
                              label: project.status.label,
                              color: project.status.color,
                            ),
                            const Spacer(),
                            Icon(
                              Icons.checklist_rounded,
                              size: 13,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${project.taskCount ?? 0}',
                              style: TextStyle(
                                fontFamily: 'Cairo-Bold',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (project.targetDate != null) ...[
                              const SizedBox(width: 10),
                              Icon(
                                Icons.event_outlined,
                                size: 13,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                intl.DateFormat('d/M/yyyy').format(project.targetDate!),
                                style: TextStyle(
                                  fontFamily: 'Cairo-Bold',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
