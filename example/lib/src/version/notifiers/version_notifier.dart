import 'package:minimal_mvn/minimal_mvn.dart';

import '../utils/version.dart';
import '../views/ui_states/version_ui_state.dart';

class VersionNotifier extends MMNotifier<VersionUIState> {
  VersionNotifier() : super(const VersionUIState());

  Future<void> loadVersion() async {
    final version = await getPackageVersion();
    notify(VersionUIState(version: version));
  }
}

final versionNotifierManager = MMManager<VersionNotifier>(VersionNotifier.new);
