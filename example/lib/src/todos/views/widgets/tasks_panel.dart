import 'package:flutter/material.dart';

import '../../models/data/task.dart';

class TasksPanel extends StatelessWidget {
  const TasksPanel({
    required this.tasks,
    required this.onTap,
    super.key,
  });

  final List<Task> tasks;
  final void Function(String) onTap;

  @override
  Widget build(final BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (final _, final index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task.label),
          trailing: Icon(task.isDone ? Icons.hourglass_empty : Icons.done),
          onTap: () => onTap(task.id),
        );
      },
    );
  }
}
