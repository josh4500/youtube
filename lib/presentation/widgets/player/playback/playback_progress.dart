import 'package:flutter/material.dart';

class PlaybackProgress extends StatelessWidget {
  const PlaybackProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return const LinearProgressIndicator(
      color: Colors.red,
      value: 0.5,
      backgroundColor: Colors.grey,
    );
  }
}
