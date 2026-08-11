import 'package:dio/dio.dart';

import 'package:wallet/core/constants/base_api.dart';
import 'package:wallet/core/enums/domain_enums.dart';
import 'package:wallet/core/networking/api_constans.dart';
import 'package:wallet/core/networking/api_result.dart';
import 'package:wallet/core/networking/dio_factory.dart';
import 'package:wallet/core/networking/pagination.dart';
import 'package:wallet/pages/projects/model/project_model.dart';

/// Projects data source. Extends [BaseApi] and uses the shared Dio — no
/// bespoke HTTP layer. All methods return `ApiResult`.
class ProjectsRepository extends BaseApi {
  final Dio _dio = DioFactory.getDio();

  Future<ApiResult<PagedResult<ProjectModel>>> getProjects({
    PageParams page = const PageParams(),
    String? workspaceId,
    ProjectStatus? status,
    ProjectPriority? priority,
    String? ownerId,
  }) {
    return execute(request: () async {
      final res = await _dio.get(
        ApiConstants.projects,
        queryParameters: {
          ...page.toQuery(),
          if (workspaceId != null) 'workspaceId': workspaceId,
          if (status != null) 'status': status.api,
          if (priority != null) 'priority': priority.api,
          if (ownerId != null) 'ownerId': ownerId,
        },
      );
      return PagedResult.fromJson(res.data as Map<String, dynamic>, ProjectModel.fromJson);
    });
  }

  Future<ApiResult<ProjectModel>> getProject(String id) {
    return execute(request: () async {
      final res = await _dio.get(ApiConstants.project(id));
      return ProjectModel.fromJson(res.data as Map<String, dynamic>);
    });
  }

  Future<ApiResult<ProjectModel>> createProject(CreateProjectRequest body) {
    return execute(request: () async {
      final res = await _dio.post(ApiConstants.projects, data: body.toJson());
      return ProjectModel.fromJson(res.data as Map<String, dynamic>);
    });
  }

  Future<ApiResult<ProjectModel>> updateProject(String id, UpdateProjectRequest body) {
    return execute(request: () async {
      final res = await _dio.put(ApiConstants.project(id), data: body.toJson());
      return ProjectModel.fromJson(res.data as Map<String, dynamic>);
    });
  }

  Future<ApiResult<ProjectModel>> changeStatus(String id, ProjectStatus status) {
    return execute(request: () async {
      final res = await _dio.patch(
        ApiConstants.projectStatus(id),
        data: {'status': status.api},
      );
      return ProjectModel.fromJson(res.data as Map<String, dynamic>);
    });
  }

  Future<ApiResult<bool>> deleteProject(String id) {
    return execute(request: () async {
      await _dio.delete(ApiConstants.project(id));
      return true;
    });
  }
}
