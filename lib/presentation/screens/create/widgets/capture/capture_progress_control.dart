import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

class CaptureProgressControl extends StatelessWidget {
  const CaptureProgressControl({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 36),
        const Icon(Icons.turn_left),
        const Spacer(),
        const Icon(Icons.turn_right),
        const SizedBox(width: 36),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            YTIcons.check_outlined,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
