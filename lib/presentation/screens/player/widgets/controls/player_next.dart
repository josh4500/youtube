import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/controls/player_control.dart';

class PlayerNext extends ConsumerWidget {
  const PlayerNext({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlayerControl(
      onTap: () {
        ref.read(playerRepositoryProvider).tapPlayer(PlayerTapActor.control);
      },
      builder: (context, _) {
        return const Padding(
          padding: EdgeInsets.all(4.0),
          child: Icon(Icons.skip_next),
        );
      },
    );
  }
}
