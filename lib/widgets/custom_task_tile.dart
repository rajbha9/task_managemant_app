import 'package:flutter/material.dart';
import '../model/task_model.dart';
import '../viewmodels/task_viewmodel.dart';

class CustomTaskTile extends StatelessWidget {
  final Task task;

  const CustomTaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Card(
      margin: EdgeInsets.symmetric(vertical: mediaQuery.size.height * 0.01),
      color: task.isCompleted ? Colors.green.shade50 : Colors.red.shade50,
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: task.isCompleted ? Colors.teal : Colors.orange,
          child: Icon(
            task.isCompleted ? Icons.check : Icons.pending,
            color: Colors.white,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(fontSize: mediaQuery.size.width * 0.045, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          task.description +
              (task.dueDate != null ? '\nDue: ${task.dueDate!.toLocal()}' : ''),
        ),
        trailing: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            context.read(taskProvider.notifier).toggleTaskCompletion(task);
          },
        ),
        onLongPress: () {
          context.read(taskProvider.notifier).deleteTask(task.id!);
        },
      ),
    );
  }
}

extension on BuildContext {
  read(notifier) {}
}
