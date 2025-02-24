import 'package:dart_mappable/dart_mappable.dart';
import 'package:minimal_mvn/minimal_mvn.dart';

part 'version_ui_state.mapper.dart';

@MappableClass()
class VersionUIState extends MMState with VersionUIStateMappable {
  const VersionUIState({this.version = ''});

  final String version;
}
