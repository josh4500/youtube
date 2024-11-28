import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../add_sound_screen.dart';

class AddMusicButton extends StatelessWidget {
  const AddMusicButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomActionChip(
      title: 'Add sound',
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => const AddSoundScreen(),
        );
      },
      icon: const Icon(YTIcons.music, size: 18),
      backgroundColor: Colors.black38,
      textStyle: const TextStyle(fontSize: 13),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    );
  }
}
