import 'package:dart_mappable/dart_mappable.dart';

import '../../models/data/task.dart';

part 'tasks_ui_state.mapper.dart';

@MappableClass()
class TasksUIState with TasksUIStateMappable {
  const TasksUIState({this.tasks = const []});

  final List<Task> tasks;
}
