import 'package:flutter/material.dart';

import 'player_control.dart';
import 'player_notifications.dart';

class PlayerRotateControl extends StatelessWidget {
  const PlayerRotateControl({super.key});

  @override
  Widget build(BuildContext context) {
    return PlayerControlButton(
      onTap: () => RotatePlayerNotification().dispatch(context),
      backgroundColor: Colors.transparent,
      horizontalPadding: 8,
      builder: (context, _) {
        return const Icon(Icons.screen_rotation, size: 18);
      },
    );
  }
}
