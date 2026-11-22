import 'package:material_ui/material_ui.dart';

import '../../notifiers/done_notifier.dart';
import 'tasks_panel.dart';

class DonePanel extends StatelessWidget {
  const DonePanel({super.key});

  @override
  Widget build(final BuildContext context) {
    final notifier = doneNotifierManager.notifier;

    return ListenableBuilder(
      listenable: notifier,
      builder: (final _, final _) =>
          TasksPanel(tasks: notifier.state.tasks, onTap: notifier.toggleTask),
    );
  }
}
