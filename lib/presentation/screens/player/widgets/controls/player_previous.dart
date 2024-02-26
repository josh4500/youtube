import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';

import 'player_control.dart';

class PlayerPrevious extends ConsumerWidget {
  const PlayerPrevious({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlayerControl(
      onTap: () {
        ref.read(playerRepositoryProvider).tapPlayer(PlayerTapActor.control);
      },
      enabled: false,
      builder: (context, _) {
        return const Padding(
          padding: EdgeInsets.all(4.0),
          child: Icon(
            Icons.skip_previous,
            color: Colors.white30,
          ),
        );
      },
    );
  }
}
