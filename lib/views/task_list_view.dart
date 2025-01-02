import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../model/task_model.dart';
import '../viewmodels/task_viewmodel.dart';
import '../widgets/add_task_dialog.dart';



class TaskListView extends ConsumerWidget {
  final VoidCallback toggleTheme;

  TaskListView({required this.toggleTheme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final mediaQuery = MediaQuery.of(context);
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task List',
          style: TextStyle(
            fontSize: mediaQuery.size.width * 0.06,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        actions: [
          IconButton(icon: Icon(Icons.brightness_6), onPressed: toggleTheme),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body:
          tasks.isEmpty
              ? Center(
                child: Text(
                  'No tasks available.',
                  style: TextStyle(
                    fontSize: mediaQuery.size.width * 0.05,
                    color: textColor,
                  ),
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.all(mediaQuery.size.width * 0.02),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Slidable(
                      key: ValueKey(task.id),
                      startActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                            onPressed: (context) {
                              task.isCompleted?ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.orange,
                                  content: Text('Task is already Completed',style: TextStyle(color: Colors.white),),
                                ),
                              ):{
                              ref
                                  .read(taskProvider.notifier)
                                  .toggleTaskCompletion(task),
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text('Task is Completed'),
                                ),
                              )};
                            },
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            icon: Icons.cloud_done,
                            label: 'Complete',
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                            onPressed: (context) {
                              ref
                                  .read(taskProvider.notifier)
                                  .deleteTask(task.id!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text('Task deleted'),
                                ),
                              );
                            },
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                          SlidableAction(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                            onPressed: (context) async {
                              final updatedTask = await showDialog<Task>(
                                context: context,
                                builder: (context) => AddTaskDialog(task: task),
                              );
                              if (updatedTask != null) {
                                ref
                                    .read(taskProvider.notifier)
                                    .updateTask(updatedTask);
                              }
                            },
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                        ],
                      ),
                      child: Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors:
                                task.isCompleted
                                    ? [
                                      Colors.teal.shade200,
                                      Colors.blueAccent.shade400,
                                    ]
                                    : [
                                      Colors.blueAccent.shade400,
                                      Colors.teal.shade200,
                                    ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(mediaQuery.size.width * 0.05),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  task.isCompleted
                                      ? Colors.green.shade900
                                      : Colors.orange.shade500,
                              child:
                                  task.isCompleted
                                      ? Icon(Icons.done, color: Colors.white)
                                      : Icon(Icons.pending, color: Colors.white),
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: mediaQuery.size.width * 0.045,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            subtitle: Text(
                              task.description +
                                  (task.dueDate != null
                                      ? '\nDue: ${task.dueDate!.toLocal().toString().split(' ')[0]}'
                                      : ''),
                              style: TextStyle(
                                fontSize: mediaQuery.size.width * 0.04,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal.shade300,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () async {
          final newTask = await showDialog<Task>(
            context: context,
            builder: (context) => AddTaskDialog(),
          );
          if (newTask != null) {
            ref.read(taskProvider.notifier).addTask(newTask);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
