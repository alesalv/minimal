import 'dart:async';

import 'package:minimal_mvn/minimal_mvn.dart';

import '../data/task.dart';

class TasksRepository {
  TasksRepository() {
    _streamController = StreamController<List<Task>>.broadcast(sync: true);
    _tasks = [
      const Task(id: '1', label: 'Task 1'),
      const Task(id: '2', label: 'Task 2'),
      const Task(id: '3', label: 'Task 3'),
      const Task(id: '4', label: 'Task 4', isDone: true),
      const Task(id: '5', label: 'Task 5', isDone: true),
    ];
  }

  late final StreamController<List<Task>> _streamController;
  late List<Task> _tasks;

  Stream<List<Task>> watch() {
    return _streamController.stream;
  }

  List<Task> read() => _tasks;

  void update(final String id) {
    _tasks = _tasks
        .map((final task) => task.id == id ? task.copyWith(isDone: !task.isDone) : task)
        .toList();
    _streamController.add(_tasks);
  }
}

final tasksRepositoryLocator = MMLocator(TasksRepository.new);
