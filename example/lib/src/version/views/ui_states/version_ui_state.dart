import 'package:dart_mappable/dart_mappable.dart';

part 'version_ui_state.mapper.dart';

@MappableClass()
class VersionUIState with VersionUIStateMappable {
  const VersionUIState({this.version = ''});

  final String version;
}
