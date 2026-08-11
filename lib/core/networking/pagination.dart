/// Mirrors the backend `PagedResult<T>` contract:
/// `{ items, page, pageSize, totalCount, totalPages }`.
class PagedResult<T> {
  final List<T> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;

  const PagedResult({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
  });

  bool get hasNextPage => page < totalPages;
  bool get isEmpty => items.isEmpty;

  factory PagedResult.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final rawItems = (json['items'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(fromJsonT)
        .toList();
    return PagedResult<T>(
      items: rawItems,
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? rawItems.length,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? rawItems.length,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
    );
  }

  static PagedResult<T> empty<T>() => PagedResult<T>(
        items: const [],
        page: 1,
        pageSize: 20,
        totalCount: 0,
        totalPages: 0,
      );

  PagedResult<T> mergeNext(PagedResult<T> next) => PagedResult<T>(
        items: [...items, ...next.items],
        page: next.page,
        pageSize: next.pageSize,
        totalCount: next.totalCount,
        totalPages: next.totalPages,
      );
}

/// Base query parameters for paginated list endpoints. Defaults: page 1,
/// pageSize 20 (max 100, matching the backend clamp).
class PageParams {
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  final int page;
  final int pageSize;
  final String? search;
  final String? sort;
  final bool desc;

  const PageParams({
    this.page = 1,
    this.pageSize = defaultPageSize,
    this.search,
    this.sort,
    this.desc = false,
  });

  Map<String, dynamic> toQuery() => {
        'page': page,
        'pageSize': pageSize.clamp(1, maxPageSize),
        if (search != null && search!.trim().isNotEmpty) 'search': search!.trim(),
        if (sort != null && sort!.isNotEmpty) 'sort': sort,
        if (desc) 'desc': true,
      };
}
