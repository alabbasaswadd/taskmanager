import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallet/pages/taskes/model/task_model.dart';

part 'tasks_state.freezed.dart';

@freezed
abstract class TasksState with _$TasksState {
  factory TasksState({
    @Default(false) bool isLoading,
    @Default(false) bool isError,
    @Default(false) bool isSuccess,
    @Default([]) List<TaskModel> tasks,
    String? errorMessage,
  }) = _Initial;
}
