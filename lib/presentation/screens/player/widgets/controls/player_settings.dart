import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class PlayerSettings extends StatelessWidget {
  const PlayerSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppbarAction(icon: Icons.settings_outlined);
  }
}
