import 'package:flutter/material.dart';

import '../widgets/done_panel.dart';
import '../widgets/progress_panel.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todos'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.hourglass_empty)),
              Tab(icon: Icon(Icons.done)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ProgressPanel(),
            DonePanel(),
          ],
        ),
      ),
    );
  }
}
