// Copyright (c) 2023, Ajibola Akinmosin (https://github.com/josh4500)

// All rights reserved.

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

//     * Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright notice,
//       this list of conditions and the following disclaimer in the documentation
//       and/or other materials provided with the distribution.
//     * Neither the name of {{ project }} nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      playerNotifierProvider.select((value) => value.playing),
      (previous, isPlaying) {
        _controller.value = isPlaying ? 0 : 1;
      },
    );

    final playerNotifier = ref.watch(playerNotifierProvider);
    final isPlaying = playerNotifier.playing;
    final isRestart = playerNotifier.ended;
    final isBuffering = playerNotifier.buffering;

    return PlayerControl(
      horizontalPadding: 64,
      onTap: () {
        if (!isRestart) {
          if (isPlaying) {
            ref.read(playerRepositoryProvider).pauseVideo();
          } else {
            ref.read(playerRepositoryProvider).playVideo();
          }
        } else {
          ref.read(playerRepositoryProvider).restartVideo();
        }

        ref.read(playerRepositoryProvider).sendPlayerSignal(
              PlayerSignal.showControls,
            );
      },
      builder: (context, _) {
        if (isBuffering) return const SizedBox(width: 54);
        return isRestart
            ? const Icon(
                Icons.restart_alt,
                size: 54,
                semanticLabel: 'Restart Video',
              )
            : AnimatedIcon(
                icon: AnimatedIcons.pause_play,
                progress: _animation,
                size: 54,
                semanticLabel: isPlaying ? 'Pause video' : 'Play video',
              );
      },
    );
  }
}
