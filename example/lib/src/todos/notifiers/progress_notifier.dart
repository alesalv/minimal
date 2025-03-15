import 'dart:async';

import 'package:minimal_mvn/minimal_mvn.dart';

import '../models/data/task.dart';
import '../models/repositories/tasks_repository.dart';
import '../views/ui_states/tasks_ui_state.dart';

class ProgressNotifier extends MMNotifier<TasksUIState> {
  ProgressNotifier(this.tasksRepository)
      : super(TasksUIState(tasks: tasksRepository.read().progress)) {
    _tasksSubscription = tasksRepository.watch().listen(_onTasks);
  }

  final TasksRepository tasksRepository;
  late final StreamSubscription<List<Task>> _tasksSubscription;

  void toggleTask(final String id) {
    tasksRepository.update(id);
  }

  void _onTasks(final List<Task> tasks) {
    if (!disposed) {
      notify(state.copyWith(tasks: tasks.progress));
    }
  }

  @override
  void dispose() {
    unawaited(_tasksSubscription.cancel());
    super.dispose();
  }
}

final progressNotifierManager = MMManager(() => ProgressNotifier(tasksRepositoryLocator.instance));
