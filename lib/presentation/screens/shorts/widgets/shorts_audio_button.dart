import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

class ShortsAudioButton extends StatelessWidget {
  const ShortsAudioButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TappableArea(
      padding: const EdgeInsets.all(12),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
