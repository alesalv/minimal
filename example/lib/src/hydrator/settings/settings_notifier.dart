import 'dart:async';
import 'package:flutter/material.dart';
import 'package:minimal_mvn/minimal_mvn.dart';
import 'settings_state.dart';

class SettingsNotifier extends MMNotifier<SettingsState> {
  SettingsNotifier()
      : super(
          const SettingsState(
            themeMode: ThemeMode.system,
            fontSize: 14,
            useSystemTheme: true,
          ),
        ) {
    unawaited(_initializeSettings());
  }

  final _hydrator = MMHydrator<SettingsState>(
    key: 'app_settings',
    toJson: (final state) => state.toJson(),
    fromJson: SettingsState.fromJson,
    onEvent: (final event, final error) {
      if (error != null) {
        debugPrint('Settings hydration error: $error');
      }
    },
  );

  Future<void> _initializeSettings() async {
    await hydrate(_hydrator);
  }

  Future<void> updateThemeMode(final ThemeMode mode) async {
    notify(state.copyWith(
      themeMode: mode,
      useSystemTheme: mode == ThemeMode.system,
    ),);
    await persist(_hydrator);
  }

  Future<void> updateFontSize(final double size) async {
    notify(state.copyWith(fontSize: size));
    await persistWithDebounce(_hydrator);
  }

  Future<void> setUseSystemTheme(final bool value) async {
    notify(state.copyWith(
      useSystemTheme: value,
      themeMode: value
          ? ThemeMode.system
          : state.themeMode == ThemeMode.system
              ? ThemeMode.light
              : state.themeMode,
    ),);
    await persist(_hydrator);
  }

  Future<void> resetSettings() async {
    await clearPersistedState(_hydrator);
    notify(const SettingsState(
      themeMode: ThemeMode.system,
      fontSize: 14,
      useSystemTheme: true,
    ),);
  }
}
