import 'package:bloc/bloc.dart';

import 'package:wallet/core/enums/domain_enums.dart';
import 'package:wallet/core/networking/api_result.dart';
import 'package:wallet/core/networking/pagination.dart';
import 'package:wallet/core/state/paged_list_state.dart';
import 'package:wallet/pages/projects/api/projects_repository.dart';
import 'package:wallet/pages/projects/model/project_model.dart';

class ProjectsCubit extends Cubit<PagedListState<ProjectModel>> {
  ProjectsCubit({ProjectsRepository? repository})
      : _repo = repository ?? ProjectsRepository(),
        super(const PagedListState<ProjectModel>());

  final ProjectsRepository _repo;

  String? _search;
  ProjectStatus? _status;
  ProjectPriority? _priority;
  String? _workspaceId;

  Future<void> load({
    String? search,
    ProjectStatus? status,
    ProjectPriority? priority,
    String? workspaceId,
    bool refresh = false,
  }) async {
    _search = search;
    _status = status;
    _priority = priority;
    _workspaceId = workspaceId ?? _workspaceId;

    emit(state.copyWith(status: refresh ? ViewStatus.refreshing : ViewStatus.loading));

    final result = await _repo.getProjects(
      page: PageParams(page: 1, search: _search),
      workspaceId: _workspaceId,
      status: _status,
      priority: _priority,
    );

    result.when(
      success: (paged) => emit(PagedListState.fromPage(paged)),
      failure: (e) => emit(state.copyWith(status: ViewStatus.error, error: e.message)),
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;
    emit(state.copyWith(status: ViewStatus.loadingMore));

    final result = await _repo.getProjects(
      page: PageParams(page: state.page + 1, search: _search),
      workspaceId: _workspaceId,
      status: _status,
      priority: _priority,
    );

    result.when(
      success: (paged) => emit(PagedListState.fromPage(paged, existing: state.items)),
      failure: (e) => emit(state.copyWith(status: ViewStatus.success, error: e.message)),
    );
  }

  Future<void> refresh() => load(
        search: _search,
        status: _status,
        priority: _priority,
        workspaceId: _workspaceId,
        refresh: true,
      );
}
