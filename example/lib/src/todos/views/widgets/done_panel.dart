import 'package:flutter/material.dart';

import '../../notifiers/done_notifier.dart';
import 'tasks_panel.dart';

class DonePanel extends StatelessWidget {
  const DonePanel({super.key});

  @override
  Widget build(final BuildContext context) {
    final notifier = doneNotifierManager.notifier;

    return ListenableBuilder(
      listenable: notifier,
      builder: (final _, final __) => TasksPanel(
        tasks: notifier.state.tasks,
        onTap: notifier.toggleTask,
      ),
    );
  }
}
