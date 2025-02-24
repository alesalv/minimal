import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'chroma_counter/views/pages/chroma_counter_page.dart';
import 'counter/views/pages/counter_page.dart';
import 'version/views/widgets/version_panel.dart';

class MinimalApp extends StatelessWidget {
  const MinimalApp({super.key});

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E293B), // Dark blue-gray
          foregroundColor: Colors.white, // For text and icons
        ),
      ),
      home: const HomePage(),
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
      body: Stack(
        children: [
          Center(
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
                          builder: (final context) => const ChromaCounterPage(),
                        ),
                      ),
                    );
                  },
                  child: const Text('Chroma Counter'),
                ),
              ],
            ),
          ),
          const Positioned(
            right: 16,
            bottom: 16,
            child: VersionPanel(),
          ),
        ],
      ),
    );
  }
}
