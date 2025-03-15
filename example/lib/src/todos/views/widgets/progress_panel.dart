import 'package:flutter/material.dart';

import '../../notifiers/progress_notifier.dart';
import 'tasks_panel.dart';

class ProgressPanel extends StatelessWidget {
  const ProgressPanel({super.key});

  @override
  Widget build(final BuildContext context) {
    final notifier = progressNotifierManager.notifier;

    return ListenableBuilder(
      listenable: notifier,
      builder: (final _, final __) => TasksPanel(
        tasks: notifier.state.tasks,
        onTap: notifier.toggleTask,
      ),
    );
  }
}
