import 'package:dio/dio.dart';

import 'package:wallet/core/constants/base_api.dart';
import 'package:wallet/core/enums/domain_enums.dart';
import 'package:wallet/core/networking/api_constans.dart';
import 'package:wallet/core/networking/api_result.dart';
import 'package:wallet/core/networking/dio_factory.dart';
import 'package:wallet/core/networking/pagination.dart';
import 'package:wallet/pages/taskes/model/task_item_model.dart';

class TasksRepository extends BaseApi {
  final Dio _dio = DioFactory.getDio();

  Future<ApiResult<PagedResult<TaskItemModel>>> getTasks({
    PageParams page = const PageParams(),
    String? projectId,
    TaskItemStatus? status,
    TaskPriority? priority,
    String? assigneeId,
    String? createdById,
  }) {
    return execute(request: () async {
      final res = await _dio.get(ApiConstants.tasks, queryParameters: {
        ...page.toQuery(),
        if (projectId != null) 'projectId': projectId,
        if (status != null) 'status': status.api,
        if (priority != null) 'priority': priority.api,
        if (assigneeId != null) 'assigneeId': assigneeId,
        if (createdById != null) 'createdById': createdById,
      });
      return PagedResult.fromJson(res.data as Map<String, dynamic>, TaskItemModel.fromJson);
    });
  }

  Future<ApiResult<TaskItemModel>> getTask(String id) {
    return execute(request: () async {
      final res = await _dio.get(ApiConstants.task(id));
      return TaskItemModel.fromJson(res.data as Map<String, dynamic>);
    });
  }

  Future<ApiResult<TaskItemModel>> createTask(CreateTaskRequest body) {
    return execute(request: () async {
      final res = await _dio.post(ApiConstants.tasks, data: body.toJson());
      return TaskItemModel.fromJson(res.data as Map<String, dynamic>);
    });
  }

  Future<ApiResult<TaskItemModel>> updateTask(String id, UpdateTaskRequest body) {
    return execute(request: () async {
      final res = await _dio.put(ApiConstants.task(id), data: body.toJson());
      return TaskItemModel.fromJson(res.data as Map<String, dynamic>);
    });
  }

  Future<ApiResult<TaskItemModel>> changeStatus(String id, TaskItemStatus status) {
    return execute(request: () async {
      final res = await _dio.patch(ApiConstants.taskStatus(id), data: {'status': status.api});
      return TaskItemModel.fromJson(res.data as Map<String, dynamic>);
    });
  }

  Future<ApiResult<TaskItemModel>> addAssignee(String id, String userId) {
    return execute(request: () async {
      final res = await _dio.post(ApiConstants.taskAssignees(id), data: {'userId': userId});
      return TaskItemModel.fromJson(res.data as Map<String, dynamic>);
    });
  }

  Future<ApiResult<bool>> removeAssignee(String id, String userId) {
    return execute(request: () async {
      await _dio.delete(ApiConstants.taskAssignee(id, userId));
      return true;
    });
  }

  Future<ApiResult<bool>> deleteTask(String id) {
    return execute(request: () async {
      await _dio.delete(ApiConstants.task(id));
      return true;
    });
  }
}
