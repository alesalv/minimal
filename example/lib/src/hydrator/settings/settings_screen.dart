import 'dart:async';

import 'package:flutter/material.dart';
import 'settings_manager.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    final notifier = settingsManager.notifier;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListenableBuilder(
        listenable: notifier,
        builder: (final context, final _) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Use System Theme'),
                subtitle:
                    const Text('Automatically follow system theme settings'),
                value: notifier.state.useSystemTheme,
                onChanged: notifier.setUseSystemTheme,
              ),
              if (!notifier.state.useSystemTheme) ...[
                ListTile(
                  title: const Text('Theme Mode'),
                  trailing: DropdownButton<ThemeMode>(
                    value: notifier.state.themeMode,
                    items: [ThemeMode.light, ThemeMode.dark].map((final mode) {
                      return DropdownMenuItem(
                        value: mode,
                        child: Text(mode == ThemeMode.light ? 'Light' : 'Dark'),
                      );
                    }).toList(),
                    onChanged: (final mode) {
                      if (mode != null) {
                        unawaited(notifier.updateThemeMode(mode));
                      }
                    },
                  ),
                ),
              ],
              ListTile(
                title: const Text('Font Size'),
                subtitle: Slider(
                  value: notifier.state.fontSize,
                  min: 12,
                  max: 24,
                  divisions: 12,
                  label: notifier.state.fontSize.toString(),
                  onChanged: notifier.updateFontSize,
                ),
              ),
              ListTile(
                title: const Text('Reset Settings'),
                trailing: IconButton(
                  icon: const Icon(Icons.restore),
                  onPressed: notifier.resetSettings,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
