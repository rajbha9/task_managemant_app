import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/task_model.dart';
import '../services/database_services.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]) {
    loadTasks();
  }

  final dbHelper = DatabaseHelper.instance;

  void loadTasks() async {
    final tasks = await dbHelper.fetchTasks();
    state = tasks;
  }

  void addTask(Task task) async {
    await dbHelper.insertTask(task);
    loadTasks();
  }

  void toggleTaskCompletion(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      isCompleted: !task.isCompleted,
    );
    await dbHelper.updateTask(updatedTask);
    loadTasks();
  }

  void deleteTask(int id) async {
    await dbHelper.deleteTask(id);
    loadTasks();
  }
  void updateTask(Task updatedTask)async {
    await dbHelper.updateTask(updatedTask);
    state = [
      for (final task in state)
        if (task.id == updatedTask.id) updatedTask else task
    ];
  }
}
