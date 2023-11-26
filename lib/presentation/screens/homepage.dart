import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Consumer(
        builder: (_, ref, __) {
          return IconButton(
              onPressed: () {
                final themeMode = ref.read(preferencesProvider).themeMode.isDark
                    ? ThemeMode.light
                    : ThemeMode.dark;
                ref.read(preferencesProvider.notifier).themeMode = themeMode;
              },
              icon: const Icon(Icons.add));
        },
      ),
    );
  }
}
