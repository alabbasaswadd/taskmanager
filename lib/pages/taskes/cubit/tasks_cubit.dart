import 'package:bloc/bloc.dart';

import 'package:wallet/core/enums/domain_enums.dart';
import 'package:wallet/core/networking/api_result.dart';
import 'package:wallet/core/networking/pagination.dart';
import 'package:wallet/core/state/paged_list_state.dart';
import 'package:wallet/pages/taskes/api/tasks_repository.dart';
import 'package:wallet/pages/taskes/model/task_item_model.dart';

class TasksCubit extends Cubit<PagedListState<TaskItemModel>> {
  TasksCubit({TasksRepository? repository})
      : _repo = repository ?? TasksRepository(),
        super(const PagedListState<TaskItemModel>());

  final TasksRepository _repo;

  String? _search;
  String? _projectId;
  TaskItemStatus? _status;
  TaskPriority? _priority;
  String? _assigneeId;

  Future<void> load({
    String? search,
    String? projectId,
    TaskItemStatus? status,
    TaskPriority? priority,
    String? assigneeId,
    bool refresh = false,
  }) async {
    _search = search;
    _projectId = projectId ?? _projectId;
    _status = status;
    _priority = priority;
    _assigneeId = assigneeId ?? _assigneeId;

    emit(state.copyWith(status: refresh ? ViewStatus.refreshing : ViewStatus.loading));

    final result = await _repo.getTasks(
      page: PageParams(page: 1, search: _search),
      projectId: _projectId,
      status: _status,
      priority: _priority,
      assigneeId: _assigneeId,
    );
    result.when(
      success: (paged) => emit(PagedListState.fromPage(paged)),
      failure: (e) => emit(state.copyWith(status: ViewStatus.error, error: e.message)),
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;
    emit(state.copyWith(status: ViewStatus.loadingMore));
    final result = await _repo.getTasks(
      page: PageParams(page: state.page + 1, search: _search),
      projectId: _projectId,
      status: _status,
      priority: _priority,
      assigneeId: _assigneeId,
    );
    result.when(
      success: (paged) => emit(PagedListState.fromPage(paged, existing: state.items)),
      failure: (e) => emit(state.copyWith(status: ViewStatus.success, error: e.message)),
    );
  }

  Future<void> refresh() => load(
        search: _search,
        projectId: _projectId,
        status: _status,
        priority: _priority,
        assigneeId: _assigneeId,
        refresh: true,
      );

  void filterByStatus(TaskItemStatus? status) => load(
        search: _search,
        projectId: _projectId,
        status: status,
        priority: _priority,
        assigneeId: _assigneeId,
      );

  void addTask(TaskItemModel task) {
    if (isClosed) return;
    final updated = [task, ...state.items];
    emit(state.copyWith(
      items: updated,
      status: ViewStatus.success,
      totalCount: state.totalCount + 1,
    ));
  }

  /// Replaces a single task in the list state without an API call.
  /// Used when the details screen has already successfully changed the status.
  void updateTask(TaskItemModel updated) {
    if (isClosed) return;
    final items = state.items.map((t) => t.id == updated.id ? updated : t).toList();
    emit(state.copyWith(items: items));
  }

  Future<bool> changeStatus(String taskId, TaskItemStatus newStatus) async {
    final result = await _repo.changeStatus(taskId, newStatus);
    return result.when(
      success: (updated) {
        updateTask(updated);
        return true;
      },
      failure: (_) => false,
    );
  }
}
