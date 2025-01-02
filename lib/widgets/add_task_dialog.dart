import 'package:flutter/material.dart';

import '../model/task_model.dart';

class AddTaskDialog extends StatefulWidget {
  final Task? task; // Pass an existing task for editing

  AddTaskDialog({this.task});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      // Pre-fill fields if editing a task
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _dueDate = widget.task!.dueDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return AlertDialog(
      title: Text(
        widget.task == null ? 'Add Task' : 'Edit Task',
        style: TextStyle(fontSize: mediaQuery.size.width * 0.05, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
            ),
            SizedBox(height: mediaQuery.size.height * 0.02),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            SizedBox(height: mediaQuery.size.height * 0.02),
            Row(
              children: [
                Text(
                  _dueDate == null
                      ? 'No date chosen!'
                      : 'Due: ${_dueDate!.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(fontSize: mediaQuery.size.width * 0.04),
                ),
                Spacer(),
                TextButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _dueDate = selectedDate;
                      });
                    }
                  },
                  child: Text('Select Date'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
              final updatedTask = Task(
                id: widget.task?.id, // Retain ID for updates
                title: _titleController.text,
                description: _descriptionController.text,
                dueDate: _dueDate,
                isCompleted: widget.task?.isCompleted ?? false,
              );
              Navigator.of(context).pop(updatedTask);
            }
          },
          child: Text(widget.task == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}
