import 'package:dio/dio.dart';

import 'package:wallet/core/constants/base_api.dart';
import 'package:wallet/core/networking/api_constans.dart';
import 'package:wallet/core/networking/api_result.dart';
import 'package:wallet/core/networking/dio_factory.dart';
import 'package:wallet/core/networking/pagination.dart';
import 'package:wallet/pages/notifications/model/notification_model.dart';

class NotificationsRepository extends BaseApi {
  final Dio _dio = DioFactory.getDio();

  Future<ApiResult<PagedResult<NotificationModel>>> getNotifications({
    PageParams page = const PageParams(),
    bool? isRead,
  }) {
    return execute(request: () async {
      final res = await _dio.get(ApiConstants.notifications, queryParameters: {
        ...page.toQuery(),
        if (isRead != null) 'isRead': isRead,
      });
      return PagedResult.fromJson(res.data as Map<String, dynamic>, NotificationModel.fromJson);
    });
  }

  Future<ApiResult<int>> unreadCount() {
    return execute(request: () async {
      final res = await _dio.get(ApiConstants.notificationsUnreadCount);
      final data = res.data;
      if (data is Map && data['count'] != null) return (data['count'] as num).toInt();
      if (data is num) return data.toInt();
      return 0;
    });
  }

  Future<ApiResult<bool>> markAsRead(String id) {
    return execute(request: () async {
      await _dio.patch(ApiConstants.notificationRead(id));
      return true;
    });
  }

  Future<ApiResult<bool>> markAllAsRead() {
    return execute(request: () async {
      await _dio.patch(ApiConstants.notificationsReadAll);
      return true;
    });
  }
}
