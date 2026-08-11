import 'package:wallet/core/networking/pagination.dart';

/// Lifecycle status shared by all list screens (drives loading / empty / error
/// / success UI). Kept as plain immutable classes (no code-gen) for speed.
enum ViewStatus { initial, loading, refreshing, loadingMore, success, empty, error }

class PagedListState<T> {
  final ViewStatus status;
  final List<T> items;
  final String? error;
  final int page;
  final int totalCount;
  final bool hasMore;

  const PagedListState({
    this.status = ViewStatus.initial,
    this.items = const [],
    this.error,
    this.page = 1,
    this.totalCount = 0,
    this.hasMore = false,
  });

  bool get isInitialLoading => status == ViewStatus.loading && items.isEmpty;
  bool get isLoadingMore => status == ViewStatus.loadingMore;

  PagedListState<T> copyWith({
    ViewStatus? status,
    List<T>? items,
    String? error,
    int? page,
    int? totalCount,
    bool? hasMore,
  }) {
    return PagedListState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error,
      page: page ?? this.page,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  factory PagedListState.fromPage(PagedResult<T> result, {List<T>? existing}) {
    final items = existing == null ? result.items : [...existing, ...result.items];
    return PagedListState<T>(
      status: items.isEmpty ? ViewStatus.empty : ViewStatus.success,
      items: items,
      page: result.page,
      totalCount: result.totalCount,
      hasMore: result.hasNextPage,
    );
  }
}
