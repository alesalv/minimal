import 'package:flutter/material.dart';
import 'package:minimal_mvn/minimal_mvn.dart';

@immutable
class SettingsState implements MMState {
  const SettingsState({
    required this.themeMode,
    required this.fontSize,
    required this.useSystemTheme,
  });

  factory SettingsState.fromJson(final Map<String, dynamic> json) =>
      SettingsState(
        themeMode: ThemeMode.values[json['themeMode'] as int],
        fontSize: json['fontSize'] as double,
        useSystemTheme: json['useSystemTheme'] as bool,
      );

  final ThemeMode themeMode;
  final double fontSize;
  final bool useSystemTheme;

  Map<String, dynamic> toJson() => {
        'themeMode': themeMode.index,
        'fontSize': fontSize,
        'useSystemTheme': useSystemTheme,
      };

  SettingsState copyWith({
    final ThemeMode? themeMode,
    final double? fontSize,
    final bool? useSystemTheme,
  }) =>
      SettingsState(
        themeMode: themeMode ?? this.themeMode,
        fontSize: fontSize ?? this.fontSize,
        useSystemTheme: useSystemTheme ?? this.useSystemTheme,
      );
}
