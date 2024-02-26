import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/provider/repository/player_repository_provider.dart';
import 'package:youtube_clone/presentation/provider/state/player_state_provider.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/controls/player_control.dart';

class PlayPauseRestartControl extends ConsumerStatefulWidget {
  const PlayPauseRestartControl({super.key});

  @override
  ConsumerState<PlayPauseRestartControl> createState() =>
      PlayPauseRestartControlState();
}

class PlayPauseRestartControlState
    extends ConsumerState<PlayPauseRestartControl>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    final isPlaying = ref.read(playerNotifierProvider).playing;
    _controller = AnimationController(
      vsync: this,
      value: isPlaying ? 0 : 1,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = ref.watch(
      playerNotifierProvider.select((value) => value.playing),
    );

    final restart = ref.watch(
      playerNotifierProvider.select((value) => value.ended),
    );
    return PlayerControl(
      horizontalPadding: 32,
      onTap: () {
        if (!restart) {
          if (isPlaying) {
            _controller.forward();
            ref.read(playerRepositoryProvider).pauseVideo();
          } else {
            _controller.reverse();
            ref.read(playerRepositoryProvider).playVideo();
          }
        } else {
          ref.read(playerRepositoryProvider).restartVideo();
        }

        ref.read(playerRepositoryProvider).tapPlayer(PlayerTapActor.control);
      },
      builder: (context, animation) {
        return restart
            ? const Icon(
                Icons.restart_alt,
                size: 54,
              )
            : AnimatedIcon(
                icon: AnimatedIcons.pause_play,
                progress: _animation,
                size: 54.0,
                semanticLabel: 'Show menu',
              );
      },
    );
  }
}
