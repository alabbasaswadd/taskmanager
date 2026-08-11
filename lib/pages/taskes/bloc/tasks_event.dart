abstract class TasksEvent {}

class GetAllTasks extends TasksEvent {}

class AddTask extends TasksEvent {
  final String title;
  final String description;

  AddTask({required this.title, required this.description});
}

class UpdateTask extends TasksEvent {
  final int id;
  final String title;
  final String description;

  UpdateTask({
    required this.id,
    required this.title,
    required this.description,
  });
}

class DeleteTask extends TasksEvent {
  final int id;

  DeleteTask({required this.id});
}
