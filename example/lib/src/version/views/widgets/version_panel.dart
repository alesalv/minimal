import 'dart:async';

import 'package:flutter/material.dart';

import '../../notifiers/version_notifier.dart';

class VersionPanel extends StatefulWidget {
  const VersionPanel({super.key});

  @override
  State<VersionPanel> createState() => _VersionPanelState();
}

class _VersionPanelState extends State<VersionPanel> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (final timeStamp) => unawaited(versionNotifierManager.notifier.loadVersion()),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final notifier = versionNotifierManager.notifier;
    return ListenableBuilder(
      listenable: notifier,
      builder: (final _, final __) => Text(
        notifier.state,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0x99666666), // Semi-transparent grey
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
