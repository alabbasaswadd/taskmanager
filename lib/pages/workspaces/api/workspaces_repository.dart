import 'package:dio/dio.dart';

import 'package:wallet/core/constants/base_api.dart';
import 'package:wallet/core/networking/api_constans.dart';
import 'package:wallet/core/networking/api_result.dart';
import 'package:wallet/core/networking/dio_factory.dart';
import 'package:wallet/core/networking/pagination.dart';
import 'package:wallet/pages/workspaces/model/workspace_model.dart';

class WorkspacesRepository extends BaseApi {
  final Dio _dio = DioFactory.getDio();

  Future<ApiResult<PagedResult<WorkspaceModel>>> getWorkspaces({
    PageParams page = const PageParams(pageSize: 100),
  }) {
    return execute(request: () async {
      final res = await _dio.get(ApiConstants.workspaces, queryParameters: page.toQuery());
      return PagedResult.fromJson(res.data as Map<String, dynamic>, WorkspaceModel.fromJson);
    });
  }
}
