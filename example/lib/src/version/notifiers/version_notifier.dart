import 'package:minimal_mvn/minimal_mvn.dart';

import '../utils/version.dart';

class VersionNotifier extends MMNotifier<String> {
  VersionNotifier() : super('');

  Future<void> loadVersion() async {
    final version = await getPackageVersion();
    notify(version);
  }
}

final versionNotifierManager = MMManager<VersionNotifier>(VersionNotifier.new);
