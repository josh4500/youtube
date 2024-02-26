import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/player_notifications.dart';

import 'controls/player_overlay_controls.dart';

class PlayerComponentsWrapper extends StatelessWidget {
  final Widget child;
  final void Function(PlayerNotification notification)? handleNotification;

  const PlayerComponentsWrapper({
    super.key,
    this.handleNotification,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<PlayerNotification>(
      onNotification: (PlayerNotification playerNotification) {
        if (handleNotification != null) {
          handleNotification!(playerNotification);
        }
        // Return true to cancel the notification bubbling.
        return true;
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          const PlayerOverlayControls(),
        ],
      ),
    );
  }
}
