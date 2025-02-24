import 'package:flutter/services.dart' show rootBundle;

/// Utility to read the package version from pubspec.yaml at runtime.
///
/// Example:
/// ```dart
/// final version = await getPackageVersion();
/// print('Current version: $version'); // prints "1.0.4"
/// ```
Future<String> getPackageVersion() async {
  final content = await rootBundle.loadString('../pubspec.yaml');
  final versionLine = content.split('\n').firstWhere(
        (final line) => line.startsWith('version:'),
      );
  return versionLine.split(':')[1].trim();
}
