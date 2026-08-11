import 'package:bloc/bloc.dart';

import 'package:wallet/core/networking/pagination.dart';
import 'package:wallet/core/networking/api_result.dart';
import 'package:wallet/core/state/paged_list_state.dart';
import 'package:wallet/pages/notifications/api/notifications_repository.dart';
import 'package:wallet/pages/notifications/model/notification_model.dart';

class NotificationsState {
  final PagedListState<NotificationModel> list;
  final int unreadCount;
  const NotificationsState({
    this.list = const PagedListState<NotificationModel>(),
    this.unreadCount = 0,
  });

  NotificationsState copyWith({
    PagedListState<NotificationModel>? list,
    int? unreadCount,
  }) =>
      NotificationsState(
        list: list ?? this.list,
        unreadCount: unreadCount ?? this.unreadCount,
      );
}

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({NotificationsRepository? repository})
      : _repo = repository ?? NotificationsRepository(),
        super(const NotificationsState());

  final NotificationsRepository _repo;
  bool? _onlyUnread;

  Future<void> load({bool? onlyUnread, bool refresh = false}) async {
    _onlyUnread = onlyUnread;
    emit(state.copyWith(
      list: state.list.copyWith(status: refresh ? ViewStatus.refreshing : ViewStatus.loading),
    ));
    final result = await _repo.getNotifications(
      page: const PageParams(),
      isRead: _onlyUnread == true ? false : null,
    );
    result.when(
      success: (paged) => emit(state.copyWith(list: PagedListState.fromPage(paged))),
      failure: (e) => emit(state.copyWith(
        list: state.list.copyWith(status: ViewStatus.error, error: e.message),
      )),
    );
    refreshUnread();
  }

  Future<void> refreshUnread() async {
    final result = await _repo.unreadCount();
    result.when(
      success: (count) => emit(state.copyWith(unreadCount: count)),
      failure: (_) {},
    );
  }

  Future<void> markAsRead(String id) async {
    final result = await _repo.markAsRead(id);
    result.when(
      success: (_) {
        final updated = state.list.items
            .map((n) => n.id == id
                ? NotificationModel(
                    id: n.id,
                    workspaceId: n.workspaceId,
                    type: n.type,
                    title: n.title,
                    message: n.message,
                    isRead: true,
                    readAt: n.readAt,
                    referenceType: n.referenceType,
                    referenceId: n.referenceId,
                    createdAt: n.createdAt,
                  )
                : n)
            .toList();
        emit(state.copyWith(
          list: state.list.copyWith(items: updated),
          unreadCount: (state.unreadCount - 1).clamp(0, 1 << 30),
        ));
      },
      failure: (_) {},
    );
  }

  Future<void> markAllRead() async {
    final result = await _repo.markAllAsRead();
    result.when(
      success: (_) {
        emit(state.copyWith(unreadCount: 0));
        load(onlyUnread: _onlyUnread, refresh: true);
      },
      failure: (_) {},
    );
  }
}
