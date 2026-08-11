import 'package:dio/dio.dart';
import 'package:wallet/pages/taskes/model/task_model.dart';
import 'package:wallet/core/constants/route.dart';

class TasksApi {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  Future<List<TaskModel>> getTasks() async {
    final response = await dio.get(task);

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => TaskModel.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load tasks");
    }
  }
}
