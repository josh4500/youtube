import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/provider/state/player_state_provider.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/controls/player_control.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/player_notifications.dart';

class PlayerMinimize extends ConsumerWidget {
  const PlayerMinimize({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanded = ref.watch(
      playerNotifierProvider.select((value) => value.expanded),
    );
    return PlayerControl(
      onTap: () {
        if (expanded) DeExpandPlayerNotification().dispatch(context);
        MinimizePlayerNotification().dispatch(context);
      },
      horizontalPadding: 4,
      color: Colors.transparent,
      builder: (context, _) {
        return const RotatedBox(
          quarterTurns: 1,
          child: Icon(Icons.chevron_right_rounded),
        );
      },
    );
  }
}
