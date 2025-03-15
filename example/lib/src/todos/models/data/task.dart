import 'package:dart_mappable/dart_mappable.dart';

part 'task.mapper.dart';

@MappableClass()
class Task with TaskMappable {
  const Task({
    required this.id,
    required this.label,
    this.isDone = false,
  });

  final String id;
  final String label;
  final bool isDone;
}

extension TasksIterator on List<Task> {
  List<Task> get progress => where((final t) => !t.isDone).toList();
  List<Task> get done => where((final t) => t.isDone).toList();
}
