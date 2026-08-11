import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:wallet/pages/taskes/api/tasks_api.dart';
import 'package:wallet/pages/taskes/bloc/tasks_event.dart';
import 'package:wallet/pages/taskes/bloc/tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc() : super(TasksState()) {
    on<GetAllTasks>(_getTasks);
  }

  final TasksApi _api = TasksApi();

  Future<void> _getTasks(GetAllTasks event, Emitter<TasksState> emit) async {
    emit(state.copyWith(
      isLoading: true,
      isError: false,
      isSuccess: false,
      errorMessage: null,
    ));

    try {
      final tasks = await _api.getTasks();
      emit(state.copyWith(isLoading: false, isSuccess: true, tasks: tasks));
    } on DioException catch (e) {
      final message = _resolveDioError(e);
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  String _resolveDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'تعذّر الاتصال بالخادم، تحقق من اتصالك بالإنترنت';
      case DioExceptionType.connectionError:
        return 'لا يوجد اتصال بالإنترنت';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode != null && statusCode >= 500) {
          return 'خطأ في الخادم، يرجى المحاولة لاحقاً';
        }
        return 'حدث خطأ أثناء جلب البيانات';
      default:
        return 'حدث خطأ غير متوقع';
    }
  }
}
