import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'counter/views/pages/counter_page.dart';
import 'hydrator/settings/settings_manager.dart';
import 'hydrator/settings/settings_screen.dart';
import 'morphing_widget/views/pages/morphing_widget_page.dart';

class MinimalApp extends StatelessWidget {
  const MinimalApp({super.key});

  @override
  Widget build(final BuildContext context) {
    final notifier = settingsManager.notifier;
    return ListenableBuilder(
        listenable: notifier,
        builder: (final context, final _) {
      return  MaterialApp(
      themeMode: notifier.state.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const HomePage(),
      );
        },
    );
  }
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/minimal.svg',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
            const Text('Minimal'),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            ElevatedButton(
              onPressed: () {
                unawaited(
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (final context) => const CounterPage(),
                    ),
                  ),
                );
              },
              child: const Text('Counter'),
            ),
            ElevatedButton(
              onPressed: () {
                unawaited(
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (final context) => const MorphingWidgetPage(),
                    ),
                  ),
                );
              },
              child: const Text('Morphing Widget'),
            ),
            ElevatedButton(
              onPressed: () {
                unawaited(
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (final context) => const SettingsScreen(),
                    ),
                  ),
                );
              },
              child: const Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
