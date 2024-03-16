import 'dart:ui';

import 'package:flutter/material.dart';

class PlayerAmbient extends StatelessWidget {
  const PlayerAmbient({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Finish ambient
    // return const SizedBox();
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.13),
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
            Colors.transparent,
          ],
          stops: const [0.4, 0.6, 0.8, 1.0],
        ),
      ),
    );
  }
}
