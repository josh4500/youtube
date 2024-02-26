import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';
import 'package:youtube_clone/presentation/provider/state/player_state_provider.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/controls/player_control.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/player_notifications.dart';

class PlayerFullscreen extends ConsumerWidget {
  const PlayerFullscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Check if Expanded or Fullscreen control mode
    const bool expandedMode = true;

    final expanded = ref.watch(
      playerNotifierProvider.select((value) => value.expanded),
    );
    return PlayerControl(
      onTap: () {
        if (expandedMode) {
          if (!expanded) {
            ExpandPlayerNotification().dispatch(context);
          } else {
            DeExpandPlayerNotification().dispatch(context);
          }
        } else {
          FullscreenPlayerNotification().dispatch(context);
        }
        ref.read(playerRepositoryProvider).tapPlayer(PlayerTapActor.control);
      },
      color: Colors.transparent,
      horizontalPadding: 0,
      builder: (context, _) {
        return const Icon(Icons.fullscreen);
      },
    );
  }
}
