import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class PlayerWatermark extends StatelessWidget {
  const PlayerWatermark({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomOrientationBuilder(
      onLandscape: (context, _) {
        return Align(
          alignment: Alignment.bottomRight,
          child: Container(
            width: 50,
            height: 50,
            color: Colors.red.shade400,
            margin: const EdgeInsets.all(16),
          ),
        );
      },
      onPortrait: (_, __) => const SizedBox(),
    );
  }
}
